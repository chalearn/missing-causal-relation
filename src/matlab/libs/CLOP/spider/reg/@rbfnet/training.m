function [d,a] =  training(a,d)
  
  if a.algorithm.verbosity>0
    disp(['training ' get_name(a) '.... '])
  end
    
  X=get_x(d);
  Y=get_y(d);
  
  [N,idim]=size(X);
  [N,odim]=size(Y);
  nrofcenters=a.nr_of_centers;
  myassert(nrofcenters>0,'Require an a-priori defined number of centers');

  if a.init_with_kmeans == 1 
      km=kmeans;
      km.k=nrofcenters;
      [r,kmresult]=train(km,d);
      centers=kmresult.mu;
  else
      % getboundingbox
      minX=min(X);
      maxX=max(X);
      centers= repmat(minX,nrofcenters,1);
      for i=1:nrofcenters
          centers(i,:)=centers(i,:)+(maxX-minX)*diag(rand(idim,1));
      end
  end

%   residual=Y;
  
  maxiter=100;
  
  if (a.fixgamma==0)
      gamma=rand;
  else
      gamma=a.gamma;
  end
  
  etag=1e-3;
  etac=1e-2;
  
  L=Inf;Lold=0;
  
  epsilon=a.eps;
  maxiter=a.maxiter;
  % Naive gradient descent algorithm 
  %% TODO dynamic learning step
  i=0;
  while (i<maxiter & norm(L-Lold)>epsilon)
    
    i=i+1;
    if( mod(i,50)==0)
        fprintf('Rbfnet squared loss: %f\n',norm(residual));
    end
    
    %calculate response matrix
    D2=calc(distance,data(centers),data(X)).^2;
    K=exp(-gamma * D2);
    alpha= pinv(K)*Y;
    Yest=K*alpha;
    residual = Yest-Y;
    
     if(a.fixgamma==0)
      gamma=gamma*exp(etag*gradient_gamma(residual,K,alpha,D2));
     end

     centers=centers+etac*gradient_centers(residual,K,alpha,gamma,D2,centers,X);
     Lold=L;
     L=norm(residual);
     
     if(Lold<=L)
         etag=etag*0.75;
         etac=etac*0.75;
     '+'
     end
%      L
%      etag,L
  end
  
  a.gamma=gamma;
  a.centers=centers;
  a.alpha=alpha;

  if a.algorithm.do_not_evaluate_training_error
        d=set_x(d,get_y(d)); 
  else
        d=test(a,d);
end

  
function dc=gradient_centers(residual,K,alpha,g,D2,centers,X)
 dc=0*centers;
 k=size(centers,1);
 for l=1:k
 dc(l,:)= -sum(diag(K(:,l))*diag(residual)*alpha(l)*g*(X-repmat(centers(l,:),size(X,1),1)));
 end

function dg=gradient_gamma(residual,K,alpha,D2)
dg=sum(residual.*((K.*D2)*alpha));
  
function myassert(cond,errmsg)
if (isempty(cond))
    error(errmsg);
end