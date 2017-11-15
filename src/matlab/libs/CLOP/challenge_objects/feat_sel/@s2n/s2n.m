function a = s2n(hyper) 

%=========================================================================
% Signal to noise correlation coefficient feature ranking
%=========================================================================   
% A=S2N(H) returns a s2n object initialized with hyperparameters H. 
%
% The train method ranks features with the Pearson correlation coefficient.
% The top ranking features are selected and the new data matrix returned.
% The test method uses the ranking obtained with the train method.
% It selects the top ranking features and returns the new data matrix.
% The hyperparameters can be changed after construction of the object
% to allow users to vary the number of features without retraining.
% 
%  Hyperparameters, and their defaults
%
%   f_max           -- Maximum number of features to be selected;
%                     if f_max=Inf then no limit is set on the number of
%                     features.
%   w_min           -- Threshold on the ranking criterion W;
%                     if W(i) <= w_min, the feature i is eliminated.
%                     W is between 0 and 1. A negative value of w_min
%                     means all the features are kept.
%  balance          -- if 0, regular s2n
%                   -- if 1, balance the number of positively correlated
%                       and negatively correlated features.
%                   -- if 2, add non-correlated genes in the middle (for
%                   calibration purpose.
%  If both theta and featnum are provided, both criteria are satisfied,
%  i.e. feature_number <= featmax and W > theta.
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
%  d=gen(toy); a=s2n('w_min=0.2'); a.f_max=20; [r,a]=train(a,d);
%  get_fidx(a)  % lists the chosen features in  order of importance, using 20 features
%
%=========================================================================
% Reference : T. R. Golub et al.
% Molecular Classification of Cancer: Class Discovery and Class Prediction by Gene Expression Monitoring} ,
% Science, vol. 286, pp. 531-537,1999
%=========================================================================

% Isabelle Guyon -- isabelle@clopinet.com -- September 2005

a.IamCLOP=1;

% hyperparameters
a.display_fields={'f_max', 'w_min', 'balance'};
a.f_max= default(Inf, [0 Inf]);             % number of features 
a.w_min= default(-Inf, [-Inf Inf]);         % threshold of the criterion    

a.cache_file='';                            % file that caches the weights
a.balance=0;                                % indicates whether to balance the number of positive and negative features

% model
a.fidx=[];
a.W=[];

algoType=algorithm('s2n');
a= class(a,'s2n',algoType);

a.algorithm.do_not_evaluate_training_error=0; 
a.algorithm.verbosity=1;

% overwrite the defaults
eval_hyper;



   
  
