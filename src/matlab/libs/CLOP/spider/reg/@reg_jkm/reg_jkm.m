function a = reg_jkm(hyper)   
%===============================================================================      
% Structure Output Learning using Joint Kernel Method 
%===============================================================================     
%
% A=reg_jkm(H) returns a reg_jkm object initialized with hyperparameters H.   
%  
% Requires input of the form (x_i,z_i) -> y_i where y_i is a scalar
% and one is interested in learning the map y=f(x,z) in order to find
% pre-images z*=g(x)=argmax_z* f(x,z*). 
%
% Expects the data object to be of the form
% d.X{1}=x_: d.X{2}=z_: d.Y=y_: 
% and x_ and z_ should be normalized so ||x_i||=||z_i||=1
% 
% Hyperparameters, and their defaults   
%  ridge=1e-5           -- regularization on input kernel  
%  child=kernel         -- the kernel for inputs stored as member "child"  
%  ok=kernel            -- the kernel for outputs  
%  output_preimage=0    -- output index from training sample of  preimage   
%                          instead of actual label  
%                                   =1    -- output f(x,y), i.e. the score assigned to these
%                                           examples
%
%   training_method =0 (default) --Perform ridge regression to learn the
%                                       mapping
%                                       =1 -- Perform kernel matching pursuit
%                                       to learn the mapping
%
%   max_Xsv             = 100 -- maximal number of Support Vectors. This
%                                   parameter is only taken into account
%                                   when training_method is set to 1
%   optimizer             = 'full_inversion' -- Optimization method for
%                                       kernel matching pursuit
%
% Model  
%  alpha                -- the weights   
%  Xsv                  -- the Support Vectors  
%  
% Methods:  
%  train, test 
%
% Example:
%  a=reg_jkm; 
%  a.child = joint_kernel;
%  m=100;n=2; % example of identity map in 2 dimensions, 10 examples
%  I=randn(m,n);
%  X=[I; randn(m,n)]; 
%  Z=[I; I];
%  Y=[ones(m,1) ; zeros(m,1)];
%  % data gives 20 examples of correct map (top) and 10 false maps (bottom)
%  % now.. normalize data to have length 1 (required)
%  for i=1:length(X)
%     X(i,:)=X(i,:)/norm(X(i,:));
%     Z(i,:)=Z(i,:)/norm(Z(i,:));
%  end
%  % setup data
%  
%  d=data(X); d2 = data(Z);
%  dj = joint_data({d,d2},Y);
%  [r a]=train(a,dj);
%
%=============================================================================== 
% Reference  : 
% Author     : 
% Link       :  N/A
%===============================================================================   
   
    
  %hyperparams    
  a.ridge=1e-5;  
  a.output_preimage=0;  
  a.training_method=0;
  a.optimizer='full_inversion';
  a.max_Xsv = 200;
  a.child=joint_kernel;  
%   a.ok= kernel; 
  a.do_not_evaluate_training_error = 0;
  a.regression_method = kmp;
  a.selection_criterion = 'kmp';
  
  % model   
  a.alpha=[];  
  a.Xsv=[];  
  a.W=[];
  
  p=algorithm('reg_jkm'); p.use_signed_output=0;  
  a= class(a,'reg_jkm',p);  
   
  if nargin==1,  
    eval_hyper;  
  end;  
