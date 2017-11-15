function [d,a] =  training(a,d)


%if alpha empty in child | alpha full in rss model, train child (first train/retrain).
%if alpha full in child, empty in rss, only train rss.

if isempty(a.child.alpha) | ~isempty(a.alpha) % train algorithm first
   [r a.child]=train(a.child,d);
end  

alpha=a.child.alpha; 
svs=find(sum(abs(alpha)',1)>1e-5); a.Xsv=get(d,svs);
K=calc(a.child.child,get(d,svs));
newalpha=alpha(svs,:)*0; alpha=alpha(svs,:); origalpha=alpha;
w2=[]; for i=1:size(alpha,2) w2(i)=alpha(:,i)'*K*alpha(:,i); end;
worig=w2;
loops=1;
disp('compressing..');
svs=[];


while max(w2)>a.tolerance
   %w is determined by alpha ONLY
  
   wx=alpha(:,1)*0;
   for i=1:size(alpha,2)  
    tmp= w2(i) - ((K*alpha(:,i)).^2 ./ diag(K)) ;  % calc all (w.x_i)^2/||x_i||^2 for each w
    wx=wx+tmp; 
   end       
   [val,I]=min(wx); % find arg max w.x_i    
   svs=union(svs,I);
   
   for i=1:size(alpha,2) 
    ai= (K(I,:)*alpha(:,i)) / K(I,I);   %   a_i = (x_i,w) / (x_i,x_i)  , optimal alpha
    alpha(I,i)=alpha(I,i)-ai;          %   w <- w - a_i x_i, project out learnt part of w 
    newalpha(I,i)=newalpha(I,i)+ai;    %   wnew <- wnew + a_i x_i, add to new w 
   end 

   if loops>1 & mod(loops,a.backfit)==0   % find optimal alphas by backfitting
     inv=pinv(K(svs,svs)); % only need to compute inverse once
     alpha=origalpha;
     for i=1:size(alpha,2)
      beta=inv*K(svs,:)*origalpha(:,i);
      newalpha(svs,i)=beta;  alpha(svs,i)=alpha(svs,i)-beta;
     end
   end
   
   w2=[]; for i=1:size(alpha,2) w2(i)=alpha(:,i)'*K*alpha(:,i); end;
    
   %txt='iteration %d : ||w_orig||^2=%1.3f  ||w_new||^2=%1.3f  ||w_orig-w_new||^2=%1.3f';
   %disp(sprintf(txt,[loops worig   newalpha'*K*newalpha w2]));
   txt='iteration %d : max||w_orig-w_new||^2=%1.3f svs=%d';
   disp(sprintf(txt,[loops max(w2) sum(sum(abs(newalpha)',1)>0)]));
   
   
   loops=loops+1;
end

a.alpha=newalpha;
if isfield('b0',struct(a.child))
 a.b0=a.child.b0;
else
 a.b0=0;
end

if a.algorithm.do_not_evaluate_training_error==1   
  d=set_x(d,get_y(d));
else
  d=test(a,d);
end
 