function a = pca_bank(hyper) 
%=============================================================================
% PCA_BANK data object to create a filter bank for the PCA transform             
%=============================================================================  
% a=pca_bank(hyper) 
%
% Generates a "pca_bank" data object. 
%
%   Hyperparameters
%   f_max               -- Maximum number of components
%
%   Data
%   X                   -- matrix of match filters (templates)
%                          Note: the lines are templates and the columns
%                          features. For 2 dimensional templates, the image
%                          is turned into a vector by concatenating its
%                          columns and transposing the vector: m(:)'.
%                          The function "show" restores the 2 dimensional
%                          character of the templates.
%
% Note: using the object with a match filter allows performing a principal
% component transform. This differs from pc_extract in 2 ways:
% - the data are not first centered
% - the eigenvectors are not scaled by the singular values.
%
% Methods:
%  train, test, get_dim, show
%
%=============================================================================
% Author of code: Isabelle Guyon -- isabelle@clopinet.com -- November 2005
%=============================================================================
% <<-------------hyperparameters----------------->> 
a.f_max=default(10, [0,Inf]);

% <<-------------model----------------->> 
algoType=data('pca_bank');
a= class(a,'pca_bank',algoType);

eval_hyper;
