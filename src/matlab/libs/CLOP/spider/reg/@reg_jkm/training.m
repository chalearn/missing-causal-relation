    function [res,a] =  training(a,d,loss_type)
       
  disp(['training ' get_name(a) '.... '])
  
  
  %% setup dataset
  
%   Xs=d.X;
%   
%   K1=calc(a.child,data(Xs{1})); % kernel on inputs
%   K1=K1+a.bias; % add bias
%   K2=calc(a.ok,data(Xs{2}));     % kernel in outputs
%   K=K1.*K2;         % take joint product kernel at the moment
%  
 

 
  
  
  %% do kernel regression...
  %% (replace this part with a fast chunking code later..)
  
  
  
  if a.training_method == 0 % RIDGE REGRESSION
      disp('Performing ridge regression...')
       K = calc(a.child,d);

     for i=1:length(K)
        K(i,i)=K(i,i)+a.ridge;
     end
  
      
      Kinv=inv(K); 
      Y = get_y(d);
      a.alpha=Kinv*Y;  %% calculate alphas   
      a.Xsv=d;
  end
  
  if a.training_method == 1 % KERNEL MATCHING PURSUIT
      disp('Performing kernel matching pursuit ...')
      a2=a.regression_method; 
      a2.do_not_evaluate_training_error = a.do_not_evaluate_training_error;
      a2.max_loops= a.max_Xsv; % number of SVs
      a2.optimizer = a.optimizer;
      a2.selection_criterion = a.selection_criterion;
      a2.trn_err_frac=0.02;
      a2.child = a.child;
      a2.ridge = a.ridge;
      a2.verbosity = 1;
      [tr a2]=train(a2,d);
      a.regression_method = a2;
      a.Xsv = a2.Xsv;
      a.alpha = a2.alpha;
  end
      
      
  
  if a.algorithm.do_not_evaluate_training_error==1
      res=d; res.X=res.Y;
  else
    res=testing(a,d);
  end
  