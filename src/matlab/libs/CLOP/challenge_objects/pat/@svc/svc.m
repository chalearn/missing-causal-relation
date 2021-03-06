
function a = svc(hyper) 
%=============================================================================
% SVC Support Vector Classifier object             
%=============================================================================  
% a=svc(hyperParam) 
%
% Generates a svc object with given hyperparameters.
% The kernel used is k(x,x') = (coef0+x.x')^degree exp[-gamma||x-x'||^2]
% i.e., if gamma=0 and coef0=1: the kernel is polynomial,
%       if gamma=0, degree=1, and coef0=0: the kernel is linear (default)
%       if degree=0: the kernel is a Gaussian RBF
% other combinations of coef0, degree, gamma are possible.
%
%   Hyperparameters (with defaults)
%   coef0               -- kernel bias, default=0
%   degree              -- kernel degree, default=1
%   gamma               -- kernel inverse 'witdh', default=0
%   shrinkage               -- (small) value added to the diagonal of the
%                           kernel matrix fro regularization purpose.
% 
%   Model
%    W                   -- the feature weights (for linear models)
%    alpha               -- the support vector weights
%    b0                  -- the bias
%    Xsv                 -- the Support Vectors
%    sv_idx              -- indices of the support vectors
%    compute_sv_idx      -- find the indices of the sv (not give by default)
%
% Methods:
%  train, test, default, get_w 
%
% Example:
%
%  mydata=gen(spiral({'m=200','n=2','noise=0.35'}));
%  [result,mymodel]=train(cv(svc('gamma=1')),mydata);
%  plot(mymodel{1})
%
%=============================================================================
% This code is based on an interface initially written by Jun-Cheng Chen, Kuan-Jen Peng,
% Chih-Yuan Yang and Chih-Huai Cheng from Department of Computer
% Science, National Taiwan University. The current version was prepared
% by Rong-En Fan. Modifications were made by Isabelle Guyon.
% Reference: Chih-Chung Chang and Chih-Jen Lin, LIBSVM : a library for support vector machines, 2001.
% Link: http://www.csie.ntu.edu.tw/~cjlin/libsvm
% Contact: Chih-Jen Lin <cjlin@csie.ntu.edu.tw>.
%=============================================================================

% <<------Display only "public" data members ------------->> 
a.display_fields={'coef0', 'degree', 'gamma', 'shrinkage'};
% <<------HP init: default or (default, [min, max]) or (default, {choices}) ------------->> 

a.coef0=    default(1, [0 Inf]);
a.degree=   default(1, [0 Inf]);
a.gamma=    default(0, [0 Inf]);
a.shrinkage=default(0.001, [0 Inf]);

% <<------Private members ------------->> 
a.IamCLOP=1;
a.optimizer='gunn' % libsvm28', 'osulibsvm'; 
a.sv_idx=[];
a.compute_sv_idx=0; % Save time

%   Backward comparibility HP (do not use for the challenge):
%   child=kernel         -- the kernel is stored as a member called "child"
%   C=Inf                -- the soft margin C parameter
%   optimizer='osulibsvm'  -- not available
%   alpha_cutoff=-1;     -- keep alphas with abs(a_i)>alpha_cutoff
%                           default keeps all alphas, another
%                           reasonable choice is e.g alpha_cutoff=1e-5 to remove
%                           zero alphas (i.e non-SVs) to speed up computations.

a.child=kernel;
a.C=                default(Inf, [0 Inf]);
a.balanced_C=       default(0, {0, 1});
a.balanced_ridge=   default(0, {0, 1});
a.nu =              default(0, [0 Inf]);

a.alpha_cutoff=-2; % Keep the libsvm option to store only the SVs in the model
                   % Change to -1 otherwise. 

% <<-------------model----------------->> 
a.alpha=[];
a.b0=0;
a.Xsv=[];
a.nob=0;
a.nSV=[];
a.nLabel=[];
a.W=[]; % For linear classifiers, we compute the dual representation.

algoType=algorithm('svc');
a= class(a,'svc',algoType);

a.algorithm.alias={'kern','child'}; % kernel aliases
a.algorithm.do_not_evaluate_training_error=0; 
a.algorithm.use_signed_output=0; % Return the discriminant values
a.algorithm.verbosity=1;

eval_hyper;

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













