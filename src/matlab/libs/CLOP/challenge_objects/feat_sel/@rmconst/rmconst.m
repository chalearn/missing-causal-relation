function a = rmconst(hyper) 

%=========================================================================
% Removal of constant features
%=========================================================================   
% A=RMCONST(H) returns a rmconst object initialized with hyperparameters H. 
%
% The train method identifies constant features and give them a weight zero.
% 
% Hyperparameters, and their defaults
% w_min = 0 => remove all constant features (those with weight 0)
%
%  Model
%
%  a.fidx          -- Indices of the ranked features. Best (ones) first.
%  a.W             -- Ranking criterion (weight), 1 or 0.  
%                     These values are unsorted.
%
%  Methods:
%   train, test, get_w, get_fidx
%

% Isabelle Guyon -- isabelle@clopinet.com -- September 2006

a.IamCLOP=1;
a.display_fields={'f_max', 'w_min'};
a.f_max= default(Inf, [0 Inf]);             % number of features 
a.w_min= default(0, [-Inf Inf]);         % threshold of the criterion    

% model
a.fidx=[];
a.W=[];

algoType=algorithm('rmconst');
a= class(a,'rmconst',algoType);

a.algorithm.do_not_evaluate_training_error=0; 
a.algorithm.verbosity=1;

% overwrite the defaults
eval_hyper;



   
  
