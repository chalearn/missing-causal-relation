function a = rffs(in, hyper) 

%=========================================================================
% RFFS feature ranking with Random Forests
%=========================================================================   
% A=RFFS(H) returns a Random Forest feature selection object initialized
% with hyperparameters H. 
% A=RFFS(R,H) same, but an RF object is passed as an argument, with its
% hyperparameters.
% The train method ranks features with RF.
% The top ranking features are selected and the new data matrix returned.
% The test method uses the ranking obtained with the train method.
% It selects the top ranking features and returns the new data matrix.
% The hyperparameters can be changed after construction of the object
% to allow users to vary the number of features without retraining.
% 
%  Hyperparameters, and their defaults
%
%   child=rf        -- Must use an rf as classifier. Default rf provided.
%                       The RF object may be alternatively passed like a 
%                       hyperparameter.
%   f_max           -- Maximum number of features to be selected;
%                     if feat_max=Inf then no limit is set on the number of
%                     features.
%   w_min           -- Threshold on the ranking criterion W;
%                     if W(i) <= w_min, the feature i is eliminated.
%                     W is between 0 and 1. A negative value of w_min
%                     means all the features are kept.
%              If both theta and featnum are provided, both criteria are satisfied,
%              i.e. feature_number <= featmax and W > theta.
%
%  Model
%
%  a.fidx          -- Indices of the ranked features. Best first.
%  a.W             -- Ranking criterion (weight), the larger, the better.  
%                     These values are unsorted.
%
%  Methods:
%   train, test, get_w, get_fidx
%
%  Example:
%  d=gen(toy); a=rffs('w_min=0.2'); a.f_max=20; [r,a]=train(a,d);
%  get_fidx(a)  % lists the chosen features in  order of importance, using 20 features
%
%=========================================================================
% Reference : Leo Breiman, "Random Forests", Machine Learning, vol. 45:1,
%  pp 5--32, 2001.
%=========================================================================

% Isabelle Guyon -- isabelle@clopinet.com -- September 2005

a.IamCLOP=1;

% hyperparameters
a.display_fields={'f_max', 'w_min'};
a.f_max= default(Inf, [0 Inf]);             % number of features 
a.w_min= default(-Inf, [-Inf Inf]);         % threshold of the criterion    

% model
a.fidx=[];
a.W=[];

% parse the arguments
a.child=rf;
if nargin>0 
    if ~isobject(in)       
        hyper=in;
    else
        a.child=in; 
    end
end
  
% instanciate object
algoType=algorithm('rffs');
a= class(a,'rffs',algoType);

a.algorithm.do_not_evaluate_training_error=0; 
a.algorithm.verbosity=1;

% overwrite the defaults
eval_hyper;


if ~(strcmp(a.child.algorithm.name, 'rf'))
error('This is not an rf algorithm');
end

   
  
