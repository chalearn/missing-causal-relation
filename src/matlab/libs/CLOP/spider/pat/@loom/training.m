function [results,alg] =  training(alg,d)
       
  %[results,algorithm] =  training(algorithm,data,loss)

  if alg.algorithm.verbosity>0
    disp(['training ' get_name(alg) '.... '])
  end
    
  K=get_kernel(alg.child,d,[]);   %% calc kernel
  K=K-alg.R*diag(diag(K)); K=add_ridge(K,alg,d); 
  Y=get_y(d); K=K.*(Y*Y');
  
  n=get_dim(d);
  lower=zeros(1,n*2+1); upper=ones(1,n*2+1)*Inf;
  
  options= optimset('MaxIter',10000);
  w=linprog([ones(1,n)*alg.A 0  ones(1,n)],[-K -Y -eye(n)],-ones(1,n),[],[],lower,upper);
    
  alpha=w(1:n) .* Y; b=w(n+1);
  alg.alpha=alpha;
  alg.b0=-b;
  alg.Xsv=d;
     
  results=test(alg,d);
  







