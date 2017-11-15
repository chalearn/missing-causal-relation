function [d,a] =  training(a,d)

if isempty(a.child.alpha) | ~isempty(a.alpha) % train algorithm first
   [r a.child]=train(a.child,d);
end    

alpha=a.child.alpha; 
%na=norm(alpha);alpha=alpha/na;

svs=find(sum(abs(alpha)',1)>1e-5); 
try 
    a.Xsv=get(a.child.Xsv,svs);
catch
    a.Xsv=get(a.child.X,svs);
end
K=calc(a.child.child,a.Xsv);
 
%if a.dont_use_noisy_pts
%  svs2=find(abs(alpha(svs))>1e-5 & abs(alpha(svs))<max(alpha(svs))-1e-5);    
%end 
y=get_y(d,svs);   
alpha=alpha(svs,:);  
disp('compressing..'); 

if a.lambda==0  % set automatically
    a.lambda=mean(diag(0.001*alpha'*K*alpha)); 
end
len=size(K,1);  
reg=ones(len,1); 
if a.penalize_small==1  % min \sum (1/alpha_i) beta_i
if size(alpha,2)>1
    reg= mean(abs(alpha),2) ./ max(abs(alpha)')';
else
    reg= mean(abs(alpha)) ./ abs(alpha);
end
end  

opts= optimset('display','on','MaxIter',10000,'LargeScale','off'); 

%K2=K .*(y*y');
%[beta,lag,dual] = quadsolve(2*K2,[-2*K2*abs(alpha)+reg*a.lambda],[],[],Inf);
%beta= beta .* y; 

if size(alpha,2)==1    %% if only learning one output
    
    if strcmp(a.optimizer,'andre')
 [beta,lag,dual] = quadsolve(2*[K -K ; -K K ]+...
      + eye(2*length(K))*1e-5 , ...    
     [-2*K*alpha+reg*a.lambda ; ...
      +2*K*alpha+reg*a.lambda ],[],[],10*max(abs(alpha)));
else
 opts= optimset('display','off','MaxIter',10000,'LargeScale','off');
 [beta,lag,dual] = quadprog(2*[K -K ; -K K ]+...
      + eye(2*length(K))*1e-5 , ...
     [-2*K*alpha+reg*a.lambda ; ...
      +2*K*alpha+reg*a.lambda ],[],[],[],[],alpha*0,10*max(abs(alpha)),[],opts);
end;

beta= beta(1:length(alpha)) - beta(length(alpha)+1:end); 
 
else % learn multiple outputs with Scholkopf, Smola method

    K2=zeros(size(alpha,2)*size(alpha,1)*2+size(alpha,1));
    c=[];
    for i=1:size(alpha,2)
        b=[1+(i-1)*size(alpha,1)*2:(i)*size(alpha,1)*2];
        K2(b,b)=[K -K ; -K K];
        c=[c; [-2*K*alpha(:,i) ;  +2*K*alpha(:,i)]];
    end 
    K2=sparse(K2);
    c=[c ;a.lambda*reg];

A=[]; b=[]; xi=size(alpha,1)*size(alpha,2)*2;
for j=1:size(alpha,2)
for i=1:size(alpha,1)
    as=sparse(1,length(K2)); 
    as((j-1)*2*size(alpha,1)+i)=1;
    as((j-1)*2*size(alpha,1)+i+size(alpha,1))=1;
    as(xi+i)=-1;
    A=[A;as];  b=[b ;0]; 
end
end

x0=[];   %% define feasible starting point
for i=1:size(alpha,2)
 g=alpha(:,i); g1=g; g1(g1>0)=0;  g2=g; g2(g2<0)=0; 
 g2=abs(g2); g1=abs(g1);
 x0=[x0 ; g2; g1];
 %for j=1:length(g2)  x0=[x0 ; g2(j) ; g1(j)]; end;
end
x0=[x0 ; max(abs(alpha)')'];

opts= optimset('display','off','MaxIter',10000,'LargeScale','off');
betas=quadprog(2*K2,c,A,b,[],[], ...
       zeros(length(K2),1),100*ones(length(K2),1),[],opts);

   
 beta=[];
 for i=1:size(alpha,2)    
  o=(i-1)*2*size(alpha,1)+1;
  beta=[beta betas(o:o+size(alpha,1)-1)...
          - betas(o+size(alpha,1):o+size(alpha,1)*2-1)]; 
 end
end


if a.reoptimize  % reoptimize alphas
    for i=1:size(beta,2)
     svs2=find(abs(beta(:,i))>max(abs(beta(:,i)))/1000);
     Ksv=K(svs2,svs2); K2=K(svs2,:); beta2=minres(Ksv,K2*alpha(:,i),1e-6,length(Ksv));
     beta=beta*0; beta(svs2)=beta2;
    end
end


%fin=find(abs(beta)>a.alpha_cutoff);
%a.alpha=beta(fin);  
%a.Xsv=get(d,svs(fin)); 
alphas=a.child.alpha*0; alphas(svs)=beta;
a.alpha=alphas;  

try
    a.Xsv=a.child.Xsv;
catch
    a.Xsv=a.child.X;
end

%a.alpha=beta; a.Xsv=get(d,svs);
fin=find(sum(abs(a.alpha)',1)>a.alpha_cutoff);
a.alpha=a.alpha(fin,:);
a.Xsv=get(a.Xsv,fin);

if a.w2==-1 % calculate ||w-w*|^2
  a.w2 = (alpha-beta)'*K*(alpha-beta);
  disp(sprintf('||w-w*||^2=%d',a.w2));
end

try
 a.b0=a.child.b0;
catch
 a.b0=0;
end;

if a.reoptimize_b % reoptimize b
   a.b0=0; r=test(a,d);
   [x s2]=sort(r.X); y=r.Y(s2,:);
   xs=cumsum(y(end:-1:1)==1); %[cumsum(y==-1)+x(end:-1:1) y]
   %plot(cumsum(y==-1)+x(end:-1:1))
   [m1 m2]=max(cumsum(y==-1)+xs(end:-1:1));
   a.b0=-x(m2);   
   %if m2+1<=size(x,1) a.b0=-(x(m2)+x(m2+1))/2; end;
end
 
if a.algorithm.do_not_evaluate_training_error==1   
  d=set_x(d,get_y(d));
else
  d=test(a,d);
end
 
