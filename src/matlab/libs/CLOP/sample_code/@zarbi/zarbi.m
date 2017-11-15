
function a = zarbi(hyperParam) 
%=============================================================================
% ZARBI linear classifier object             
%=============================================================================  
% a=zarbi(hyperParam) 
%
% Generates a zarbi classication object (no hyperparameter.)
%
%   Model
%    W                   -- the weights
%    b0                  -- the bias
%
% Methods:
%  train, test
%
%=============================================================================
% Reference :   (Golub, 1999) Molecular Classification of Cancer: Class
%               Discovery and Class Prediction by Gene Expression Monitoring. 
%               Golub et al, Science Vol 286, Oct 1999.
% Author of code: Isabelle Guyon -- isabelle@clopinet.com -- September 2005
%=============================================================================
%
% If you are going to write new learning objects, do not use this as a
% template, rather use the template of the spider package, it offers more
% possibilities.

  a.IamCLOP=1;
  % <<------hyperparam initialisation------------->> 
  % None
  % <<-------------model----------------->> 
  a.b0=0;
  a.W=[];
  
  a.algorithm='zarbi';
  
  a= class(a,'zarbi');
  

 

 
 





