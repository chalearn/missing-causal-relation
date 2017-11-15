function a = relvm_r(hyper)

%=========================================================================
% The relevance vector machine for regression by M.Tipping
%==========================================================================
% Implementations as in SparseLib 1.0
% See : http://research.microsoft.com/mlp/RVM/relevance.htm
%
% Comments from -gb-:
% Note : So far requires centered data !! 
% Note that if you get an error due to "Bad conditioned Hessian" 
% its an inherent problem in the implementation. Mostly this implementation
% works with rbf and rarely with a linear kernel.
% 
% Furthermore if you try to solve a multivariate regression problem the
% code automatically recognises and you get a multi_reg(relvm_r) object
% back!
% 
% Example:
% d=gen(toyreg({'o=2','n=3'}))
% [r,a]=train(relvm_r(kernel('rbf',1)),d)
% 
%=========================================================================
% Reference : The Relevance Vector Machine
% Author    : Michael Tipping 
% Link      : http://citeseer.ist.psu.edu/tipping00relevance.html
%=========================================================================

 % hyperparams 
    
    % used kernel.
    a.child     = kernel;
    a.Xsv=[];
    % Maximum Number of Iterations
    a.maxIts    = 1000; 


    
    a.used=[];
    a.marginal=[];
    a.alpha=[];
    a.beta=[];
    a.gamma=[];
    


    
% Plot Information  
%    a.monitorIts =  0;



    a.bias =    0;
    
    a.beta0      = 1e2;
    
    a.prune_point= 50;		% percent

  p=algorithm('relvm_r');
  a= class(a,'relvm_r',p);

  a.algorithm.use_signed_output=0;
 
  if nargin==1,
    eval_hyper;
  end;
