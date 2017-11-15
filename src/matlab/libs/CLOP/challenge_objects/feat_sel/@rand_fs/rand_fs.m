function a = rand_fs(hp) 

%=========================================================================
% Set the feature subset to a given fixed subset
%=========================================================================   
% A=RAND_FS(hp) returns an object that selects a random subset of features.
%
%  a.f_max         -- Number of features
%
%  Model
%
%  a.fidx          -- Indices of the features given by the child.
%  a.W             -- for compatibility: all 1.
%
%  Methods:
%   train, test, get_w, get_fidx

% Isabelle Guyon -- isabelle@clopinet.com -- jan 2010

a.IamCLOP=1;
a.display_fields={};

% hyperparameters
a.f_max= default(Inf, [0 Inf]);  

% model
a.fidx=[];
a.W=[];

algoType=algorithm('rand_fs');
a= class(a,'rand_fs',algoType);

a.algorithm.do_not_evaluate_training_error=0; 
a.algorithm.verbosity=1;

% overwrite the defaults
eval_hyper;



   
  
