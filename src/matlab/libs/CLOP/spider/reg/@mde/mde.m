function a = mde(hyper) 
%=========================================================================    
% Multiple output ridge regression object [Deprecated]
%=========================================================================  
% A=MDE(H) returns an object initialized with hyperparameters H. 
% 
% Performs ridge regression independently for each column we wish
% to learn, which only means inverting a single (kernel) matrix
%
% Hyperparameters, and their defaults
%  ridge=1e-13;         -- a ridge on the kernel
%  indices = []         -- indices of a reduced set of centers to be used
%                          for learning. ([] means use all training set)
%  child=kernel;        -- the kernel is stored as a member called "child"
%  use_b=1              -- find a threshold, otherwise fix to 0 
%
% Model
%  alpha                -- the weights
%  b0                   -- the threshold
%  X                    -- the set of centers
%
% Methods:
%  train, test, get_w 
%=========================================================================  
% Reference : Ridge Regression Learning Algorithm in Dual Variables
% Author    : C. Saunders , A. Gammerman and V. Vovk
% Link      : http://citeseer.ist.psu.edu/saunders98ridge.html
%=========================================================================

  %hyperparams 
  a.ridge=10^(-13);
  a.child = kernel;
  a.indices = [];
  a.use_b=1;
   
  % model 
  a.alpha = [];
  a.b0=0;
  a.X=[];
  
  p=algorithm('mde');
  p.use_signed_output=0;
  a= class(a,'mde',p);
 
  if nargin==1,
    eval_hyper;
  end;

  

