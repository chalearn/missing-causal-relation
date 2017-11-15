
function a = anorm(hyper) 
% ========================================================================   
% L1 Norm Minimization for kernel classifiers.  
% ======================================================================== 
%  Minimize ||\alpha||_norm describing kernel expansion, under 
%  separability constraints. [currently only for pattern recognition and
%  norms 0, 1 and 2]
%  
% A=ANORM(H) returns an anorm object initialized with hyperparameters H. 
%
% Hyperparameters, and their defaults:
%  norm=1               -- norm to use, i.e. minimize ||\alpha||_norm
%  ridge=1e-12          -- a ridge on the kernel
%  child=kernel         -- the kernel is stored as a member called "child"
% 
% Model:
%  alpha                -- the weights
%  b0                   -- the threshold
%  Xsv                  -- the Support Vectors
%
% Methods:
%  train, test
% Example:
% 
%  [r,a]=train(anorm('norm=1'),gen(toy));
%  [r,a]=train(anorm('norm=2'),gen(toy));
%  [r,a]=train(anorm({'norm=0',kernel('rbf',1)}),gen(toy));
% ========================================================================
% Refernce  : Use of the Zero-Norm With Linear Models and Kernel Methods  
% Author    : Jason Weston, André Elisseeff, Bernd Schölkopf, Mike Tipping
% Link      : http://citeseer.ist.psu.edu/531078.html
% ========================================================================

  %hyperparams 
  a.norm=1;
  a.ridge=1e-12;
  a.child=kernel;
  
  % model 
  a.alpha=[];
  a.b0=0;
  a.Xsv=[];
  
  p=algorithm('anorm');
  a= class(a,'anorm',p);
 
  if nargin==1,
    eval_hyper;
  end;
