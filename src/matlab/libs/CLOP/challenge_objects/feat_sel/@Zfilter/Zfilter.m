function a = Zfilter(hyper) 

%=========================================================================
% Feature ranking according to a heuristic filter designed for Dexter
%=========================================================================   
% A=ZFILTER(H) returns a ZFILTER object initialized with hyperparameters H. 
%
% Removes the features which have less than w_min non-zero values.
% 
%  Hyperparameters, and their defaults: none
%
%   f_max           -- Maximum number of features to be selected;
%                     if f_max=Inf then no limit is set on the number of
%                     features.
%   w_min           -- Threshold on the ranking criterion W; 
%                       which is the number of non-zero values.
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
%
%  Methods:
%   train, test, get_w, get_fidx
%
%  Example:
%  d=gen(toy); a=Zfilter('w_min=2'); [r,a]=train(a,d);
%  get_fidx(a)  % lists the chosen features in  order of importance
%
% Isabelle Guyon -- isabelle@clopinet.com -- December 2005

% hyperparameters
a.display_fields={'f_max', 'w_min'};
a.f_max= default(Inf, [0 Inf]);             % number of features 
a.w_min= default(-Inf, [-Inf Inf]);         % threshold of the criterion    

% model
a.fidx=[];
a.W=[];

algoType=algorithm('Zfilter');
a= class(a,'Zfilter',algoType);

a.algorithm.do_not_evaluate_training_error=0; 
a.algorithm.verbosity=1;

% overwrite the defaults
eval_hyper;



   
  
