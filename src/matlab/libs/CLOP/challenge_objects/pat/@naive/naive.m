
function a = naive(hyper) 
%=============================================================================
% NAIVE Bayes linear classifier object             
%=============================================================================  
% a=naive(hyperParam) 
%
% Generates a Naive Bayes classication object no hyperparameter.
%
%   Model
%    W                   -- the weights
%    b0                  -- the bias
%
% Methods:
%  train, test, default, get_w 
%
%=============================================================================
% References :   1) Pattern Classification, 
%                   R. O. Duda, and P. E. Hart, and D. G. Stork,
%                   John Wiley and Sons, 2001.
%                2) Machine Learning, Tom Mitchell, McGraw Hill, 1997.
% Author of code: Isabelle Guyon -- isabelle@clopinet.com -- September 2005
%=============================================================================

a.IamCLOP=1;
% <<------hyperparam initialisation------------->> 
a.display_fields={};

% <<-------------model----------------->> 
a.binary=0;           % if 1 use frequency counts, else use Gaussian classifier
a.b0=0;
a.W=[];

algoType=algorithm('naive');
a= class(a,'naive',algoType);

a.algorithm.do_not_evaluate_training_error=0; 
a.algorithm.use_signed_output=0; % Return the discriminant values
a.algorithm.verbosity=1;

% there are no hyperparameters
%eval_hyper;
 

 
 





