function a = Pearson(hyper) 

%=========================================================================
% Feature ranking according to the Pearson correlation coefficient
%=========================================================================   
% A=Pearson(H) returns a Pearson object initialized with hyperparameters H. 
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
%                     W is positive. A negative value of w_min
%                     means all the features are kept.
%   pval_max        -- Threshold on the pvalue. if pval(i)>pval_max
%                      feature i is eliminated. 0<=pval<=1.
%                      pval_max=1 means all the features are kept.
%   fdr_max         -- Same as pval_max but for the fdr.
%   eqvar           -- 0/1 flag indicating whether the 2 classes have equal
%                      variance.
%  balance          -- if 0, regular s2n
%                   -- if 1, balance the number of positively correlated
%                       and negatively correlated features.
%                   -- if 2, add non-correlated genes in the middle (for
%                   calibration purpose.
%  If several thresholds are provided, all criteria are satisfied,
%  e.g. feature_number <= f_max and W > theta. The maximum number of
%  features is never exceeded.
%
%  Model
%
%  a.fidx          -- Indices of the ranked features, according to a.W. Best first.
%                     Note: this order is the same as the pvalue ranking
%                     order by may differ from the fdr ranking order.
%                     Only the indices of the features matching all the
%                     threshold criteria are returned.
%  a.W             -- Ranking criterion abs(T statistic), the larger, the better.  
%                     These values are unsorted. All the values are
%                     returned, not just the ones matching the threshold
%                     criteria.
%  a.pval          -- Pvalues or false positive rate (fpr). These values are unsorted.
%  a.fdr           -- False discovery rate estimate as fpr*n_selected/n_total
%
%  Methods:
%   train, test, get_w, get_fidx, get_pval, get_fdr
%
%  Example:
%  d=gen(toy); a=Pearson('w_min=0.2'); a.f_max=20; [r,a]=train(a,d);
%  get_fidx(a)  % lists the chosen features in  order of importance, using 20 features
%
% Isabelle Guyon -- isabelle@clopinet.com -- December 2005

% hyperparameters
a.display_fields={'f_max', 'w_min', 'pval_max', 'fdr_max', 'eqvar', 'balance'};
a.f_max= default(Inf, [0 Inf]);             % number of features 
a.w_min= default(-Inf, [-Inf Inf]);         % threshold of the criterion    
a.pval_max= default(1, [0 1]);              % threshold on the pvalue or fpr
a.fdr_max= default(Inf, [0 Inf]);           % threshold on the fdr 
a.eqvar= default(1, {0, 1});                % whether the classes have equal variance
a.balance=0;                                % indicates whether to balance the number of positive and negative features

% model
a.fidx=[];
a.w=[]; % signed weights
a.W=[]; % unsigned weights (unless balance>0, in which case signed too)
a.pval=[];
a.fdr=[];

algoType=algorithm('Pearson');
a= class(a,'Pearson',algoType);

a.algorithm.do_not_evaluate_training_error=0; 
a.algorithm.verbosity=1;

% overwrite the defaults
eval_hyper;



   
  
