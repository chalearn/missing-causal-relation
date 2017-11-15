function a = calibrant(hyper) 

%=========================================================================
% Selection of uncorrelated features to serve as calibrant
%=========================================================================   
% A=CALIBRANT(H) returns a calibrant object initialized with hyperparameters H. 
% 
%  Hyperparameters, and their defaults
%
%   f_max           -- Maximum number of features to be selected;
%                     if f_max=Inf then no limit is set on the number of
%                     features.
%   w_min           -- Threshold on the ranking criterion W (not used, here
%                     for compatibility with other methods);
%   contrast        -- a vector of the same dimension as the number of
%                       samples indicating a direction to contrast with
%                       (for example a super-feature that is a linear 
%                       combination of previously selected features).
%
%  Model
%
%  a.fidx          -- Indices of the ranked features. Best first.
%  a.W             -- Ranking criterion.
%
%  Methods:
%   train, test, get_w, get_fidx
%

% Isabelle Guyon -- isabelle@clopinet.com -- April 2013

a.IamCLOP=1;

% hyperparameters
a.display_fields={'f_max', 'w_min'};
a.f_max= default(Inf, [0 Inf]);             % number of features 
a.w_min= default(-Inf, [-Inf Inf]);         % threshold of the criterion    

a.contrast=[];
a.cache_file='';                            % file that caches the weights

% model
a.fidx=[];
a.W=[];

algoType=algorithm('calibrant');
a= class(a,'calibrant',algoType);

a.algorithm.do_not_evaluate_training_error=0; 
a.algorithm.verbosity=1;

% overwrite the defaults
eval_hyper;



   
  
