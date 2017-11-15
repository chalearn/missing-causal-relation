function a = kmeans_bank(hyper) 
%=============================================================================
% KMEANS_BANK data object to create a filter bank for the KMEANS transform             
%=============================================================================  
% a=kmeans_bank(hyper) 
%
% Generates a "kmeans_bank" data object. 
%
%   Hyperparameters
%   f_max               -- Maximum number of components (clusters)
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
% Methods:
%  train, test, get_dim, show
%
%=============================================================================
% Author of code: Isabelle Guyon -- isabelle@clopinet.com -- November 2005
%=============================================================================
% <<-------------hyperparameters----------------->> 
a.f_max=default(10, [0,Inf]);

% <<-------------model----------------->> 
algoType=data('kmeans_bank');
a= class(a,'kmeans_bank',algoType);

eval_hyper;
