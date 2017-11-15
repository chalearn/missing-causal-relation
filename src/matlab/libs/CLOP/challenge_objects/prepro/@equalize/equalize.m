
function a = equalize(hyper) 
%=============================================================================
% EQULIZE object for preprocessing by non-linear transformation          
%=============================================================================  
% a=equalize(hyper) 
%
% Generates a "equalize" object. 
%
% Sorts of the values in the matrix and tries to roughly map them to their
% rank using a piece-wise linear approximation of the distribution of
% values.
%
%    knots              -- number of knots in the piece-wise linear approximation.              
%
% Methods:
%  train, test 
%
%=============================================================================
% Author of code: Isabelle Guyon -- isabelle@clopinet.com -- October 2012
%=============================================================================

a.IamCLOP=1;

% <<------hyperparam initialisation------------->> 
a.display_fields={'knots'};
a.knots=   default(10, [2 Inf]);

% <<------model------------->>
a.xsamp=[]; % will be vector of dim knots
a.ysamp=[]; % will be vector of dim knots
algoType=algorithm('equalize');
a= class(a,'equalize',algoType);

a.algorithm.verbosity=1;

eval_hyper;

 

 
 





