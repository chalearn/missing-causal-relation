function a = cal_rfe(in, hyper) 

%=========================================================================
% Recursive feature elimination feature ranking with X classifier
% plus adding calibrants
%=========================================================================   
% A=CAL_RFE(H) returns a rfe object initialized with hyperparameters H. 
% A=CAL_RFE(X,H), where X is an classifier object with its hyperparameters.
%
% The train method ranks features with the RFE method using SVC as a classifier.
% The top ranking features are selected and the new data matrix returned.
% The test method uses the ranking obtained with the train method.
% It selects the top ranking features and returns the new data matrix.
% The hyperparameters can be changed after construction of the object
% to allow users to vary the number of features without retraining.
% NOTE: the spider contains a more powerful version of RFE allowing
% to use other classifiers than SVC.
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
%  filter_fmax      -- Inf: no effect. filter_fmax is the number of
%                       features pre-selected with a univariate method (s2n
%                       for classification and Pearson otherwise.
%  balance          -- if 0 for regular RFE
%                         1 for RFE with equal proportions of under- over-
%                         expressed features
%                         2 for a mix of calibrants selected by RFE
%                         3 for equal proportions of under- over-
%                         expressed features and calibrants
%                         4 for calibrants added after balanced RFE
%                         (similar to 3)
%                         5 for contrast variables added instead of
%                         calibrants
%                         6 for equal proportions of under-, over-
%                         calibrants and contrasts
%
%
%  Model
%
%  a.fidx          -- Indices of the ranked features. Best first.
%  a.W             -- Weights used throughout elimination.
%
%  Methods:
%   train, test, get_w, get_fidx
%

% Isabelle Guyon -- isabelle@clopinet.com -- April 2013

a.IamCLOP=1;

% hyperparameters (public)
a.display_fields={'f_max', 'div2', 'balance', 'filter_fmax'};
a.f_max=  default(Inf, [0 Inf]);       % number of features    
a.div2=default(1, [0 1]);              % flag determining whether to divide
                                       % by 2 the number of features at 
                                       % each iteration or go one by one
a.filter_fmax=  default(Inf, [0 Inf]); % the number of features filtered   

a.child=kridge;
a.cache_file='';                       % file that caches the weights
a.balance=0;                           % indicates whether to balance the number of positive and negative features

a.UNIREG=[];
a.UNICLA=[];
a.UNI=[];
a.RFE=[];
a.CAL=[];

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

algoType=algorithm('cal_rfe');
a= class(a,'cal_rfe',algoType);

a.algorithm.do_not_evaluate_training_error=0; 
a.algorithm.verbosity=1; % 0, 1, 2

% overwrite the defaults
eval_hyper;
a.child.algorithm.verbosity=0;

% Number of univariate features should exceed the number of RFE features
a.filter_fmax=max(a.f_max, a.filter_fmax);

fmax_uni=sprintf('f_max=%d', a.filter_fmax);
if a.balance<4
    % Chain of univariate FS and RFE
    bal=sprintf('balance=%d', a.balance);
    fmax_rfe=sprintf('f_max=%d', a.f_max);
else
    % Two threads, one for RFE and one for CALIBRANT
    bal=sprintf('balance=%d', 1);
    fmax_rfe=sprintf('f_max=%d', a.f_max/2);
end

div2=sprintf('div2=%d', a.div2);

a.UNIREG=Pearson({fmax_uni, bal});
a.UNICLA=s2n({fmax_uni, bal});
a.RFE=xrfe(a.child, {fmax_rfe, div2, bal});


