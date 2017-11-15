function a = dualperceptron(hyper) 
% ========================================================================   
% Kernel Perceptron with optional margin.
% ======================================================================== 
%  
% A=DUALPERCEPTRON(H) returns a dualperceptron object initialized with hyperparameters H. 
%
%  The dualperceptron object trains a potentially kernelized perceptron.
% 
% Hyperparameters (with defaults)
%  max_loops=100        -- Maximum number of sweeps through the data
%  margin=0             -- potential margin with which to train on 
%  alpha_cutoff=-1;     -- keep alphas with abs(a_i)>max(a)/alpha_cutoff
%                           default keeps all alphas, another
%                           reasonable choice is e.g alpha_cutoff=1e5 to remove
%                           zero alphas (i.e non-SVs) to speed up computations.
% Model
%  child=kernel         -- the kernel is stored as a member called "child"
%  alpha                -- the weights
%  Xsv                  -- the "Support Vectors"
%
% Methods:
%  train, test 
%
% Example:
%  d=gen(toy2d);
%  [r,a]=train(dualperceptron('max_loops=20'),d);
%  plot(a)
% 
% d=gen(spiral({'m=200','n=2','noise=0.35'}));
% [r,a]=train(dualperceptron(kernel('rbf',1)),d)
% plot(a)
%
%=========================================================================
%  Reference : Pattern Classification
%  Author    : Richard O. Duda , Peter E. Hart
%  Link      : http://www.amazon.com/exec/obidos/tg/detail/-/0471056693/002-6279399-2828812?v=glance
% =========================================================================


  % hyperparameters
  a.max_loops=100;
  a.margin=0;
  a.alpha_cutoff=-1;

  % model 
  a.child=kernel;
  a.alpha=[];
  a.Xsv=[];
  a.error=[];
  
  p=algorithm('dualperceptron');
  a= class(a,'dualperceptron',p);
 
  a.algorithm.alias={'kern','child'}; % kernel aliases
  
  if nargin==1,
    eval_hyper;
  end;
  
  
