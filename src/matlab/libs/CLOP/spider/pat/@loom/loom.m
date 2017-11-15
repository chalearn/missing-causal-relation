
function a = loom(hyper) 
%================================================================================  
% Leave One Out SVM  by Weston et al. 
%================================================================================  
% A=LOOM(H) returns a loom object initialized with hyperparameters H. 
%
% Hyperparameters, and their defaults
%  R=1                  -- the soft margin parameter K=K-R*diag(diag(K))
%  A=0.001;             -- additional regularization on alphas, A*||alpha||_1
%  ridge=1e-12;         -- a ridge on the kernel
%  balanced_ridge=0     -- for unbalanced data
%  child=kernel         -- the kernel is stored as a member called "child"
% 
% Model
%  alpha                -- the weights
%  b0                   -- the threshold
%  Xsv                  -- the Support Vectors
%
% Methods:
%  train, test
% c1=[2,0];
% c2=[-2,0];
% X1=randn(50,2)+repmat(c1,50,1);
% X2=randn(50,2)+repmat(c2,50,1);
% 
% d=data([X1;X2],[ones(50,1);-ones(50,1)]);
% [r,a]=train(cv(loom,'folds=2'),d);
%=================================================================================
% Reference : Leave-One-Out Support Vector Machines.
% Author    : J. Weston
% Link      : IJCAI'99
%=================================================================================

  %hyperparams 
  a.A=0.001;
  a.R=1;
  a.ridge=1e-12;
  a.balanced_ridge=0;
  a.child=kernel;
  
  % model 
  a.alpha=[];
  a.b0=0;
  a.Xsv=[];
  
  p=algorithm('loom');
  a= class(a,'loom',p);
 
  if nargin==1,
    eval_hyper;
  end;
