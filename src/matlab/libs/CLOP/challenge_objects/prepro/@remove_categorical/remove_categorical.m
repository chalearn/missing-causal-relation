
function a = remove_categorical(cate_idx) 
%=============================================================================
% REMOVE_CATEGORICAL object for removing categorical variables           
%=============================================================================  
% a=remove_categorical(cate_idx) 
%
% Generates a "remove_categorical" object. 

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

algoType=algorithm('remove_categorical');
a= class(a,'remove_categorical',algoType);

a.algorithm.verbosity=1;

%eval_hyper;










