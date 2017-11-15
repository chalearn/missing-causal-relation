function a = mutinf(c,hyper)

%=========================================================================
% Feature selection by mutual information
%=========================================================================  
% A=MUTINF(C,H) returns a mutinf object initialized with hyperparameters H given a classifier C. 
%
% Performs feature selection by means of the mutual information between attributes and the target.
% If there is a given number of features to select, this number of features is selected according to
% the ranking based upon the mutatul information.
% 
% If no number of features to select is given, a probalistic forward selection is used:
% A feature is selected, if P(I > epsilon) >= 95%, where I is the mutual information between the attribute
% and the target. (c.f. Zaffalon, Hutter, Robust Feature Selection by Mutual Information Distributions)
% Here epsilon is set to the mutual information that exists between a normally distributed random feature
% and the target.
%
% Hyperparameters, and their defaults%  
%  feat=[]		-- number of features to be selected 
%  method='regression'  -- use feature selection for regression or classification
%  c                    -- learning algorithm (e.g. svm)
%
% Model
%  rank                 -- the ranking of the features
%  child	        -- learning algorithm (e.g. svm)
%
% Methods:
%  train, test, get_w 
%
% Example:
%  a=mutinf(svm); a.method='classification';a.feat=10; 
%  [r,a]=train(a,toy); loss(test(a,toy))
%
%=========================================================================
% Reference : Robust Feature Selection by Mutual Information Distributions  
% Author    : Marco Zaalon and Marcus Hutter 
% Link      : http://citeseer.ist.psu.edu/566806.html
%=========================================================================

  a.output_rank=0; % don't output labels, output selected features 
  a.feat=[];
  a.method='regression';
  a.child = c;
 
  % model           
 
  a.rank=[];
  
  p=algorithm('mutinf');
  a= class(a,'mutinf',p);
  if nargin==2
    eval_hyper;
  end  
  
