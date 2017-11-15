function a = relief(hyper) 

%=========================================================================
% Relief feature ranking
%=========================================================================   
% A=RELIEF(H) returns a pearson object initialized with hyperparameters H. 
%
% The train method ranks features with the Relief coefficient.
% The top ranking features are selected and the new data matrix returned.
% The test method uses the ranking obtained with the train method.
% It selects the top ranking features and returns the new data matrix.
% The hyperparameters can be changed after construction of the object
% to allow users to vary the number of features without retraining.
% 
%  Hyperparameters, and their defaults
%
%   f_max           -- Maximum number of features to be selected;
%                     if feat_max=Inf then no limit is set on the number of
%                     features.
%   w_min           -- Threshold on the ranking criterion W;
%                     if W(i) <= w_min, the feature i is eliminated.
%                     Weights are non-negative. A negative value of w_min
%                     means all the features are kept.
%  If both theta and featnum are provided, both criteria are satisfied,
%  i.e. feature_number <= featmax and W > theta.
%   k_num            -- Number of nearest hits or misses.
%
%  Model
%
%  a.fidx          -- Indices of the ranked features. Best first.
%  a.W             -- Ranking criterion (weight), the larger, the better.  
%                     These values are unsorted.
%
%  Note: in case of memory problems, the argument chunk_num can be used
%        to increase the number of chunks.
%
%  Methods:
%   train, test, get_w, get_fidx
%
%  Example:
%  d=gen(toy); a=relief({'w_min=0.2', 'k_num=1'}); a.f_max=20; [r,a]=train(a,d);
%  get_fidx(a)  % lists the chosen features in  order of importance, using 20 features
%
%=========================================================================
% Reference : A practical approach to feature selection, K. Kira and L. Rendell,
%             International Conference on Machine Learning, 1992.
%=========================================================================

% Isabelle Guyon -- isabelle@clopinet.com -- September 2005

a.IamCLOP=1;

% hyperparameters
a.display_fields={'f_max', 'w_min', 'k_num'};
a.f_max= default(Inf, [0 Inf]);             % number of features 
a.w_min= default(-Inf, [-Inf Inf]);         % threshold of the criterion    
a.k_num= default(4, [0 Inf]);               % number of "neighbors"

% model
a.fidx=[];
a.W=[];

% Private parameters: number of chunks
% If the number of chunks is not specified, it is computed automatically.
% Set this number to a large value if you have memory problems
a.chunk_num=[];

algoType=algorithm('relief');
a= class(a,'relief',algoType);

a.algorithm.do_not_evaluate_training_error=0; 
a.algorithm.verbosity=1;

eval_hyper;




   
  
