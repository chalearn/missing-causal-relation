function a = fixed_fs(child) 

%=========================================================================
% Set the feature subset to a given fixed subset
%=========================================================================   
% A=FIXED_FS(child) returns a fixed_fs object initialized with the child (the feature subset). 
%
%
%  Model
%
%  a.fidx          -- Indices of the features given by the child.
%  a.W             -- for compatibility: all 1.
%
%  Methods:
%   train, test, get_w, get_fidx

% Isabelle Guyon -- isabelle@clopinet.com -- jan 2010

if nargin<1, child=[]; end

a.IamCLOP=1;
a.display_fields={};

% hyperparameters
% NONE  

% model
a.fidx=child;
a.W=ones(size(a.fidx));

algoType=algorithm('fixed_fs');
a= class(a,'fixed_fs',algoType);

a.algorithm.do_not_evaluate_training_error=0; 
a.algorithm.verbosity=1;

% overwrite the defaults
%eval_hyper;



   
  
