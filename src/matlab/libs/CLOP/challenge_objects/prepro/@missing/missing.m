
function a = missing(hyper) 
%=============================================================================
% MISSING object for preprocessing by filling missing values             
%=============================================================================  
% a=missing(hyperParam) 
%
% Generates a "missing" object. 
% Replace the missing values (identified by NaN) by their median in training data.
%   Hyperparameter:
%  none
%
% Methods:
%  train, test 
%
%=============================================================================
% Author of code: Isabelle Guyon -- isabelle@clopinet.com -- February 2009
%=============================================================================

a.IamCLOP=1;

% <<------hyperparam initialisation------------->> 
a.display_fields={};

% <<-------------model----------------->> 
a.median=[];           

algoType=algorithm('missing');
a= class(a,'missing',algoType);

a.algorithm.verbosity=1;

%eval_hyper;










