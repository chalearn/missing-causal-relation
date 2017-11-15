function a = feat_sel(feats,rank_alg,classify_alg,hyper)

%=========================================================================
% FEAT_SEL feat_sel object
%=========================================================================  
% a=feat_sel(feats,rank_alg,classify_alg,hyper)
% 
% A convenient way of combining a feature ranking algorithm with a classifier
% for many different numbers of features without retraining the
% ranking classifier. You should specify a vector of number of
% features (feats) a ranking algorithm (rank_alg) and a
% classification algorithm (classify_alg) plus optional hyperparameters.
%  
%   Note: (usually the vector (feats) should be smallest value
%   first as the ranking algorithm will only be trained on the 
%   first value, and some algorithms such as
%   l0 and rfe will provide a better ranking this way)
%
%
% Hyperparameters, and their defaults
%  feats=[]               -- features to be tried
%
% Model
%  rank_alg, classify_alg -- underlying original algorithms
%  child                  -- combination of algorithms together
%
% Methods:
%  train, test
%
% Example:
% % perform feature selection with fisher and classification with svm
% % for between 1 and 20 features selected
% a=feat_sel([1:20],fisher,svm('ridge=0.01'));
% [tr,a]=train(a,toy); 
% r=test(a,toy)
% loss(r)
%
%=========================================================================
% Reference : 
% Author    : 
% Link      : 
%=========================================================================
  
  a.feats=feats;
  a.store_all=0;
  
  if nargin>1 
      a.rank_alg=rank_alg; 
  else 
      a.rank_alg=rfe(svm); 
  end
  if nargin>2 
      a.clas_alg=classify_alg; 
  else 
      a.clas_alg=svm; 
  end;
    
  a.rank_alg.output_rank=1;

  a.rank_alg.output_rank=1;
  b=param(a.rank_alg,'feat',a.feats,'force_use_prev_train=1;');
%  b=param(a.rank_alg,'feat',a.feats,'use_prev_train=1;');  
 a.child{1}=chain({ b a.clas_alg  });
   
  p=algorithm('feat_sel'); a= class(a,'feat_sel',p);
  
  if nargin==4 
      eval_hyper; 
  end;
