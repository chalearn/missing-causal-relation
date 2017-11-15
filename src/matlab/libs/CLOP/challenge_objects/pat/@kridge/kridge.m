
function a = kridge(hyper) 
%=============================================================================
% KRIDGE regression object             
%=============================================================================  
% a=kridge(hyperParam) 
%
% Generates a kernel ridge object with given hyperparameters.
% The kernel used is k(x,x') = (coef0+x.x')^degree exp[-gamma||x-x'||^2]
% i.e., if gamma=0 and coef0=1: the kernel is polynomial,
%       if gamma=0, degree=1, and coef0=0: the kernel is linear (default)
%       if degree=0: the kernel is a Gaussian RBF
% other combinations of coef0, degree, gamma are possible.
%
%   Hyperparameters (with defaults):
%    coef0               -- kernel bias, default=0
%    degree              -- kernel degree, default=1
%    gamma               -- kernel inverse 'witdh', default=0
%    shrinkage           -- (small) value added to the diagonal of the
%                           kernel matrix for regularization purpose.
%    Note that you can provide a vector of values for "shrinkage". The
%    algorithm will internally choose the best one in an efficient manner.
%    balance             -- enforce class balancing by setting the targets 
%                          to +nneg and -npos, where nneg and npos are 
%                          the number of examples of the negative and
%                          positive class.
% 
%   Model:
%    W                   -- the feature weights (for linear models)
%    alpha               -- the support vector weights
%    b0                  -- the bias
%    Xsv                 -- the Support Vectors
%    shrinkage           -- this is both a hp and a trained parameter
%
% Methods:
%  train, test, default, get_w 
%
% Example:
%
%  mydata=gen(spiral({'m=200','n=2','noise=0.35'}));
%  [result,mymodel]=train(cv(kridge('gamma=1')),mydata);
%  plot(mymodel{1})
%
%=============================================================================
% Reference : The Elements of Statistical Learning, Hastie et al.,
% Springer, 2001.
% Author of code: Isabelle Guyon -- isabelle@clopinet.com -- September 2005
%=============================================================================

% <<------Display only "public" data members ------------->> 
a.display_fields={'coef0', 'degree', 'gamma', 'shrinkage'};
% <<------HP init: default or (default, [min, max]) or (default, {choices}) ------------->> 

a.coef0=    default(1, [0 Inf]);
a.degree=   default(1, [0 Inf]);
a.gamma=    default(0, [0 Inf]);
a.shrinkage=default([], [0 Inf]);
a.balance=  default(0, {0, 1});         % enforce class balancing

% <<------Private members ------------->> 
a.IamCLOP=1;
a.child=kernel;
a.alpha_cutoff=-1; 

% <<-------------model----------------->> 
a.alpha=[];
a.b0=0;
a.Xsv=[];
a.W=[]; % For linear classifiers, we compute the dual representation.

a.mse=0;              % Training mean square error
a.mse_loo=0;          % Training leave-one-out mse
a.errate=0;           % Training error rate
a.err_loo=0;          % Training leave-one-out error rate
  
algoType=algorithm('kridge');
a= class(a,'kridge',algoType);

a.algorithm.alias={'kern','child'}; % kernel aliases
a.algorithm.do_not_evaluate_training_error=0; 
a.algorithm.use_signed_output=0; % Return the discriminant values
a.algorithm.verbosity=1;
  
eval_hyper;

% Give a default list of ridge values
if isempty(a.shrinkage)
    a.shrinkage=10.^[0:-1:-10];
end

% Backward compatibility with existing spider kernels
if a.gamma==0 & a.degree==1 & a.coef0==0
    a.child=kernel('linear');
elseif a.gamma==0 & a.degree==1 
    a.child=kernel('linear_with_bias', a.coef0);
elseif a.gamma==0 & a.coef0==1
    a.child=kernel('poly', a.degree);
elseif a.gamma==0 
    a.child=kernel('poly_with_bias', [a.coef0, a.degree]);
elseif a.degree==0
    p=[];
    if a.gamma==0, p=Inf; end
    if a.gamma==Inf, p=0; end
    if isempty(p) p=sqrt(1/(2*a.gamma)); end
    a.child=kernel('rbf', p); % Note here the parameter is the kernel witdh
else
    a.child=kernel('poly_rbf', [a.coef0, a.degree, a.gamma]);
end

 

 
 





