function [results,a] =  training(a,d)
       
  % [results,algorithm] =  training(algorithm,data,loss)

  disp(['training ' get_name(a) '.... '])
  
  K =get_kernel(a.child,d,d);
  k2=kernel; k2.calc_on_output=1;
  L =get_kernel(k2,d,d);
  K= K + L; 
  
  if (a.use_b) K=K+1; end;
    
  Kinv=K+eye(length(K))*a.ridge;
  Kinv=inv(Kinv);
 
  alpha=[];
  a.alpha=(Kinv*K)';  %% calculate alphas 
  a.X=d;
  
  results=test(a,d);
  






