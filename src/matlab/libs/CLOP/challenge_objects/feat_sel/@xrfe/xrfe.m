function a = xrfe(in, hyper) 

%=========================================================================
% Recursive feature elimination feature ranking with X classifier
%=========================================================================   
% A=XRFE(H) returns a rfe object initialized with hyperparameters H. 
% A=XFE(X,H), where X is an classifier object with its hyperparameters.
%
% The train method ranks features with the RFE method using any classifier.
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
%                     features, but the ranking is still performed.
%   div2            -- Flag (0/1) indicating whether the number of features
%                       is divided by 2 at each iteration, default 1.
%   child=x         -- Recommended use: use x as classifier. Default: linear svc.
%                      Can also use kridge (linear version): recommended
%                      for few features and large number of examples.
%                      Syntax: xrfe(scv) or xrfe(kridge)
%  balance          -- if 1, balance the number of positively correlated
%
%  Model
%
%  a.fidx          -- Indices of the ranked features. Best first.
%  a.W             -- Weights used throughout elimination.
%
%  Methods:
%   train, test, get_w, get_fidx
%
%  Example:
%  d=gen(toy); a=xrfe(kridge, 'f_max=20'); [r,a]=train(a,d);
%  get_fidx(a)  % lists the chosen features in  order of importance, using 20 features

% Isabelle Guyon -- isabelle@clopinet.com -- December 2012

a.IamCLOP=1;

% hyperparameters (public)
a.display_fields={'f_max', 'div2', 'balance'};
a.f_max=  default(Inf, [0 Inf]);       % number of features    
a.div2=default(1, [0 1]);              % flag determining whether to divide
                                       % by 2 the number of features at 
                                       % each iteration or go one by one
a.child=svc;
a.cache_file='';                       % file that caches the weights
a.balance=0;                           % indicates whether to balance the number of positive and negative features



% parse the arguments
if nargin>0 
    if ~isobject(in)       
        hyper=in;
    else
        a.child=in; 
    end
end

% hidden (private) hyperparameter (do not change)
a.w_min=-Inf;         

% model
a.fidx=[];
a.W=[];

algoType=algorithm('xrfe');
a= class(a,'xrfe',algoType);

a.algorithm.do_not_evaluate_training_error=0; 
a.algorithm.verbosity=1; % 0, 1, 2

% overwrite the defaults
eval_hyper;
a.child.algorithm.verbosity=0;


   
  
