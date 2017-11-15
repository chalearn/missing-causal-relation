
function a = normalize(hyper) 
%=============================================================================
% NORMALIZE object for preprocessing              
%=============================================================================  
% a=normalize(hyperParam) 
%
% Generates a "normalize" object.
%    The data undergoes a line by line normalization
%    with the Euclidean norm of the lines.
%    Training is irrelevant for this step.
%
% Hyperparameter:
%  center : 0 or 1. If center=1, centers the data,
%  i.e. subtract the line mean before normalizing the line.
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
a.center=default(0, {0, 1});

% <<-------------model----------------->> 
algoType=algorithm('normalize');
a= class(a,'normalize',algoType);

a.algorithm.verbosity=1;
  
eval_hyper;


 
 





