function a = gs(hyper) 

%=========================================================================
% Gram-Schmidt feature ranking
%=========================================================================   
% A=GS(H) returns a pearson object initialized with hyperparameters H. 
%
% The train method ranks features accordingto a forward selection 
% method based on Gram-Schmidt orthogonalization.
% The top ranking features are selected and the new data matrix returned.
% The test method uses the ranking obtained with the train method.
% It selects the top ranking features and returns the new data matrix.
% The hyperparameters can be changed after construction of the object
% to allow users to vary the number of features without retraining.
% *** Note however that the number f_max of features cannot be set to a
% larger number than the number f_max used for training (or it will be
% chopped at f_max.)
% 
%  Hyperparameters, and their defaults
%
%   f_max           -- Maximum number of features to be selected;
%                     if f_max=Inf then no limit is set on the number of
%                     features.
%
%  Model
%
%  a.fidx          -- Indices of the ranked features. Best first.
%  a.W             -- (unsorted) weights of the residuals of the features (first is best feature weight)
%                     Note, these are not the weights of the features.
%
%  Methods:
%   train, test, get_w, get_fidx
%
%  Example:
%  d=gen(toy); a=gs('w_min=0.2'); a.f_max=20; [r,a]=train(a,d);
%  get_fidx(a)  % lists the chosen features in  order of importance, using 20 features
%
%=========================================================================
% Reference : Ranking a random feature for variable and feature selection.
% H. Stoppiglia et al, JMLR, vol. 3 pp. 1399-1414, 2003.
%=========================================================================

% Isabelle Guyon -- isabelle@clopinet.com -- September 2005

% hyperparameter
a.display_fields={'f_max'};
a.f_max=  default(Inf, [0 Inf]);       % number of features 
a.seed = [];                           % Possible index of the first feature
a.method = 'fisher';                   % can also choose 'relief'

% Private:
a.IamCLOP=1;
a.w_min=-Inf;
%% To be implemented: GS pvalues on which a threshold can be set.

% model
a.fidx=[];
a.W=[];

algoType=algorithm('gs');
a= class(a,'gs',algoType);

a.algorithm.do_not_evaluate_training_error=0; 
a.algorithm.verbosity=1; % a verbosity of 2 shows the training progression

eval_hyper;




   
  
