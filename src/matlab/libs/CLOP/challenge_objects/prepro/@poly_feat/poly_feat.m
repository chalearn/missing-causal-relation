
function a = poly_feat(hyper) 
%=============================================================================
% POLY_FEAT object for preprocessing by adding products of features             
%=============================================================================  
% a=poly_feat(hyperParam) 
%
% Generates a "poly_feat" object. 
%   Hyperparameter:
%       f_max : Maximum number of features.
%
%   Model
%    W               -- vector of singular values (as feature weights).
%    U               -- matrix of eigenvectors.
%
% Methods:
%  train, test 
%
%=============================================================================
% Author of code: Isabelle Guyon -- isabelle@clopinet.com -- September 2005
%=============================================================================

a.IamCLOP=1;

% <<------hyperparam initialisation------------->> 
a.display_fields={'f_max'};
a.f_max= default(2000, [0 Inf]); % Limit the number of features


% <<-------------model----------------->> 

algoType=algorithm('poly_feat');
a= class(a,'poly_feat',algoType);

a.algorithm.verbosity=1;
  
eval_hyper;

 

 
 





