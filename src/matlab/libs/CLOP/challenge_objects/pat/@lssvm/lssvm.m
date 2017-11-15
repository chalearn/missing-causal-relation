
function a = lssvm(hyper) 
%=============================================================================
% LSSVM Least Square Support Vector Classifier object             
%=============================================================================  
% a=lssvm(hyperParam) 
%
%   Hyperparameters (with defaults)
%   coef0               -- kernel bias, default=0
%   degree              -- kernel degree, default=1
%   gamma               -- kernel inverse 'witdh', default=0
%   shrinkage           -- (small) value added to the diagonal of the
%                           kernel matrix for regularization purpose.
%   If any of these HP are set to [], the program optimizes them
%   with the virtual leave-one-out method.
%   balance             -- a 0/1 flag. If 1, class unbalance in compensated
%                           by weighting the ridge more heavily for the
%                           most depleted class and weighting inversely the
%                           squared errors in the PRESS criterion.
%
%   Model
%    W                   -- the feature weights (for linear models)
%    alpha               -- the support vector weights
%    b0                  -- the bias
%    Xsv                 -- the Support Vectors
%
% Methods:
%  train, test, default, get_w 
%
% Example:
%
%  mydata=gen(spiral({'m=200','n=2','noise=0.35'}));
%  [result,mymodel]=train(cv(lssvm('gamma=1')),mydata);
%  plot(mymodel{1})

% ========================================================
% Adapted from Gavin Cawley:
% Uses the virtual leave-one-out method for the LS-SVM.
% At the moment it needs the fminunc 
% routine from the MATLAB optimisation toolbox.
% ========================================================

% <<------Display only "public" data members ------------->> 
a.display_fields={'coef0', 'degree', 'gamma', 'shrinkage', 'balance'};
% <<------HP init: default or (default, [min, max]) or (default, {choices}) ------------->> 

a.coef0=    default(0, [0 Inf]);
a.degree=   default(1, [0 Inf]);
a.gamma=    default(0, [0 Inf]);
a.shrinkage=default([], [0 Inf]);
a.balance=   default(0, {0, 1});

% <<------Private members ------------->> 
a.IamCLOP=1;
a.optimizer='fminunc'; 
a.child=kernel;

% <<-------------model----------------->> 
a.alpha=[];
a.b0=0;
a.Xsv=[];
a.ber_loo=[];
a.W=[];
algoType=algorithm('lssvm');
a= class(a,'lssvm',algoType);

a.algorithm.alias={'kern','child'}; % kernel aliases
a.algorithm.do_not_evaluate_training_error=0; 
a.algorithm.use_signed_output=0; % Return the discriminant values
a.algorithm.verbosity=1;

eval_hyper;















