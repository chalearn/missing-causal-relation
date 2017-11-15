function a = emGauss(hyper) 
%=============================================================================
% Expectation maximization object for learning Gaussian mixtures             
% for continuous data only
% written by Mehreen Saeed 01 June, 2007. FAST National University of Computer
%   and Emerging Sciences   mehreen.saeed@nu.edu.pk ;
%   mehreen.mehreen@gmail.com
%=============================================================================  
% a=em(hyperParam) 
%
% Generates an em object for guassian mixture models with given hyperparameters.
% IMPORTANT the covariance matrices are diagonal cov. matrices
%
%   Hyperparameters (with defaults)
%   IterationsP = 20     -- Iterations for the em step for +ve examples
%   mixturesP=5          -- total number of mixtures to use for +ve
%                           examples
%   IterationsN = 20     -- Iterations for the em step for -ve examples
%   mixturesN=5          -- total number of mixtures to use for -ve
%                           examples
%   testGivesProb=0      -- flag to indicate whether test routine gives log prob
%   FeatureType='mixed' -- if unknown specified then it will eliminate
%                           binary features from there.  You can specify
%                           cont if only cont features are used to save
%                           time of elimination
%   Model
%    priorP             -- the prior probabilities of each mixture in +ve
%                           examples (mixturesP x 1) matrix
%    meanP              -- the mean vectors for each mixture in +ve
%                           examples (mixturesP x TotalFeatures) matrix
%    covP               --Diagonal covariance matrix for mixtures for +ve examples
%    priorN             -- the prior probabilities of each mixture in -ve
%                           examples (mixturesN x 1)
%    meanN              -- the mean vectors for each mixture in -ve
%                           examples (mixturesN x TotalFeatures) matrix
%    covN               -- Diagonal covariance matrix of mixtures for negative examples
%                       -- A total of mixturesN cov matrices of dim
%                           (features * features)
%    PosPriorP          -- the prior of class representing +ve examples
%    NegPriorP          -- the prior of clas representing -ve examples
%
% Methods:
%  train,               -- will get mixture models
%  test                 -- if transformation to prob space is required then
%  specify 'testGivesProb=1' and test function will output the
%  transformed space.  If testing is required using mixture models then set
%  this flag to false.
%    GetLogProb         -- get the log of prob matrix of instances with
%                           prob of mixtures
%
%
% Example:
%d=gen(spiral({'m=200','n=2','noise=0.35'}));
%[a b] = train(emGauss({'mixturesP =70','mixturesN=70','IterationsP=20','IterationsN=20'}),d)
% 
%
%==========================================================================
%===
% Reference : Ethem Alpaydin, "Introduction to Machine Learning", 2005.
%
%=============================================================================

  %<<------hyperparam initialisation------------->> 
  a.IterationsP=20;
  a.mixturesP=5;    
  a.IterationsN=20;
  a.mixturesN=5;
  a.testGivesProb = 0; 
  a.FeatureType = 'mixed'
  % <<-------------model----------------->> 
  a.PosPrior= 0.5;
  a.NegPrior = 0.5;
 
  a.priorP=[];
  a.meanP=[];
  a.covP = [];
  
  a.priorN=[];
  a.meanN=[];
  a.covN = [];
  
  
  algoType=algorithm('emGauss');
  a= class(a,'emGauss',algoType);
  
 if nargin==1,
    eval_hyper;
 end;





