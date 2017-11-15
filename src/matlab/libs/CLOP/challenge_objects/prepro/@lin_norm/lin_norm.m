
function a = lin_norm(hyper) 
%=============================================================================
% LIN_NORM object for preprocessing by non-linear transformation          
%=============================================================================  
% a=lin_norm(hyper) 
%
% Generates a "lin_norm" object (linear normalization). 
%
% Take each feature and replaces it by the result of linear regression to
% the target.
%
%    knots              -- number of knots in the piece-wise linear approximation.              
%
% Methods:
%  train, test 
%
%=============================================================================
% Author of code: Isabelle Guyon -- isabelle@clopinet.com -- April 2013
%=============================================================================

a.IamCLOP=1;

% <<------hyperparam initialisation------------->> 

% <<------model------------->>
a.W=[]; % weights
a.b=[]; % bias value
algoType=algorithm('lin_norm');
a= class(a,'lin_norm',algoType);

a.algorithm.verbosity=0;

eval_hyper;

 

 
 





