function a = clustub(hyper)

%=========================================================================
% Multi-class feature selection using spectral clustering
%=========================================================================  
% A=CLUSTUB(H) returns a clustub object initialized with hyperparameters H. 
%
%  Peforms feature selection via spectral clustering.
%
% Hyperparameters, and their defaults
%  feat=[]              -- number of features
%  output_rank=0        -- set to 1 if only the feature ranking matters
%                          (does not perform any classification on the data)
%  child=spectral('k=2')-- Clustering method used for training
%
% Model
%  w                    -- the weights
%  b0                   -- the threshold (when using all features)
%  rank                 -- the ranking of the features
%  d                    -- training set
%
% Methods:
%  train, test, get_w 
%
% Example:
%  d=gen(bayes({gauss([-1 3]) gauss([0 4]) gauss([1 2])})) 
%  a=chain({clustub('output_rank=1'),one_vs_rest(svm('ridge=0.01'))})
%  [r,a]=train(a,d)
%
% Note:
%  Method for multi-class feature selection.
%  To use with SVM, use:  
%  chain({clustub('output_rank=1'),one_vs_rest(svm)})
%
%=========================================================================
% Reference : Feature Selection for Unsupervised and Supervised Inference: 
%             the Emergence of Sparsity in a Weighted-based Approach. 
% Author    : Lior Wolf and A. Shashua
% Link      : http://www.cs.huji.ac.il/~shashua/papers/fts-long.pdf
%=========================================================================

  a.feat=[]; % number of features 
  a.output_rank=0; % don't output labels, output selected features 
  a.child=spectral('k=2');  
  % model           
  a.w=[];
  a.b0=0;
  a.rank=[];
  a.d=[];
  
  p=algorithm('clustub');
  a= class(a,'clustub',p);
  if nargin==1
    eval_hyper;
  end  
  
