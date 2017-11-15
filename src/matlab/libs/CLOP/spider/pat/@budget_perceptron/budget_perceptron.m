function a = budget_perceptron(hyper) 
% ========================================================================   
% Kernel Perceptron with Budget by Cramer et al.
% ======================================================================== 
% 
%  
% A=BUDGET_PERCEPTRON(H) returns a budget_perceptron object initialized with hyperparameters H. 
%
%  The budget_perceptron object trains a potentially kernelized perceptron.
% 
% Hyperparameters (with defaults)
%  cache_size=[]        -- if set to a scalar, this is the maximum cache size used
%                          after this the algorithm throws away "support vectors"
%                          if left empty, an adaptive cache is used
%  max_loops=1          -- Maximum number of sweeps through the data
%  margin=0.01          -- potential margin with which to train on 
%  alpha_cutoff=-1      -- keep alphas with abs(a_i)>max(a)/alpha_cutoff
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
%  [r,a]=train(budget_perceptron,d);
%  plot(a,d)
% 
% d=gen(spiral({'m=200','n=2','noise=0.35'}));
% [r,a]=train(budget_perceptron(kernel('rbf',.5)),d)
% plot(a,d)
%
%=========================================================================
%  Reference : Online Classification on a Budget
%  Author    : Crammer, Kandola and Singer
%  Link      : http://www.cs.huji.ac.il/~kobics/publications/budget-nips03.pdf
% =========================================================================

  
  % hyperparameters
  a.max_loops=1;
  a.margin=0.01; 
  a.alpha_cutoff=-1;
  a.cache_size=[];

  % model 
  a.child=kernel;
  a.alpha=[];
  a.Xsv=[];
  
  p=algorithm('budget_perceptron');
  a= class(a,'budget_perceptron',p);
 
  a.algorithm.alias={'kern','child'}; % kernel aliases
  
  if nargin==1,
    eval_hyper;
  end;
  
  
