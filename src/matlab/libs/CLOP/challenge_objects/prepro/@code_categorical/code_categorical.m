
function a = code_categorical(cate_idx) 
%=============================================================================
% MISSING object for coding categorical variables           
%=============================================================================  
% a=code_categorical(cate_idx) 
%
% Generates a "code_categorical" object. 
% Replace the code values by new ones corresponding to the mean of the
% target values in that category.
% Important: the categories should be numbered 1 to c; 0 is used for
% missing values.
%
%   Hyperparameter:
%  cate_idx -- A vector containing the indices of categorical variables.
%              If not provided, all variables with a number of unique
%              values lower than 10% of the number of examples will be
%              considered categorical.
%
% Methods:
%  train, test 
%
%=============================================================================
% Author of code: Isabelle Guyon -- isabelle@clopinet.com -- February 2009
%=============================================================================

a.IamCLOP=1;

% <<------hyperparam initialisation------------->> 
if nargin<1
    a.cate_idx=[];
else
    a.cate_idx=cate_idx;
end
a.display_fields={};

% <<-------------model----------------->> 
a.code_array={};           

algoType=algorithm('code_categorical');
a= class(a,'code_categorical',algoType);

a.algorithm.verbosity=1;

%eval_hyper;










