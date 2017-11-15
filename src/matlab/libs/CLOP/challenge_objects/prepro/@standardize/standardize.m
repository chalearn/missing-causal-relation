
function a = standardize(hyper) 
%=============================================================================
% STANDARDIZE object for preprocessing by standardization             
%=============================================================================  
% a=standardize(hyperParam) 
%
% Generates a "standardize" object. 
% Performs a standardization of the features by subtracting the mean
% and dividing by the standard deviation.
%   Hyperparameter:
%   center               -- 0/1 value. If 0, do not subtract the mean.
%                           The default is 1.
%
%   Model
%    mu                  -- the mean
%    sigma               -- the standard deviation
%
% Methods:
%  train, test 
%
%=============================================================================
% Author of code: Isabelle Guyon -- isabelle@clopinet.com -- September 2005
%=============================================================================

a.IamCLOP=1;

% <<------hyperparam initialisation------------->> 
a.display_fields={'center'};
a.center= default(1, {0,1});

% <<-------------model----------------->> 
a.mu=[];           
a.sigma=[];

algoType=algorithm('standardize');
a= class(a,'standardize',algoType);

a.algorithm.verbosity=1;

eval_hyper;










