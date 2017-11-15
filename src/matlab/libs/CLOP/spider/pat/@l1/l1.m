function a = l1(hyper) 
%===================================================================   
% L1 norm for linear classifiers.
%===================================================================  
% minimize l1 norm , i.e |w|_1 
%    under separability contraints (w.x_i+b)>1
%  
% A=L1(H) returns an l1 object initialized with hyperparameters H. 
%
% Hyperparameters, and their defaults:
% 
% Model:
%  alpha                -- the weights of the hyperplane
%  b0                   -- the threshold
%
% Methods:
%  train, test
%===================================================================
% Reference : 
% Author    : 
% Link      : 
%===================================================================

  % model 
  a.w=[];
  a.b0=0;

  
  p=algorithm('l1');
  a= class(a,'l1',p);
 
  if nargin==1,
    eval_hyper;
  end;
