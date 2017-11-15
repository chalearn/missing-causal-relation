
function a = pc_extract(hyper) 
%=============================================================================
% PC_EXTRACT object for preprocessing by extracting the principal components             
%=============================================================================  
% a=pc_extract(hyperParam) 
%
% Generates a "pc_extract" object. 
%   Hyperparameter:
%       f_max : Maximum number of features (principal components).
%       After training, this number can be reduced without re-training,
%       but not enlarged.
%       Use: a.f_max=new_value;
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
a.f_max= default(2000, [0 Inf]); % Limit the number of principal components to 2000


% <<-------------model----------------->> 
a.mu=[];    % Feature means
a.W=[];     % Singular values
a.U=[];     % Eigenvectors

algoType=algorithm('pc_extract');
a= class(a,'pc_extract',algoType);

a.algorithm.verbosity=1;
  
eval_hyper;

 

 
 





