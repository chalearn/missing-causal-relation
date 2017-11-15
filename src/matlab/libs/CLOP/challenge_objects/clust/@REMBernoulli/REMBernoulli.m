function a = REMBernoulli(hyper) 
%=============================================================================
% Expectation maximization object for learning bernoulli mixtures             
% for binary data only using regularized version
% written by Mehreen Saeed 27 October, 2007. FAST National University of Computer
%   and Emerging Sciences   Pakistan mehreen.saeed@nu.edu.pk ;
%   mehreen.mehreen@gmail.com
%=============================================================================  
% a=REMBernoulli(hyperParam) 
%
% Generates a regularized em object for bernoulli mixture models with given hyperparameters.
%
%
%   Hyperparameters (with defaults)

%   IterationsP = 20     -- Iterations for the em step for +ve examples
%   mixturesP=5          -- total number of mixtures to use for +ve
%                           examples
%   IterationsN = 20     -- Iterations for the em step for -ve examples
%   mixturesN=5          -- total number of mixtures to use for -ve
%                           examples
%   gamma=0.05           -- regularization constant.  Set it to 0 to get
%                           plain em
%   testGivesProb=0      -- flag to indicate whether test routine gives log prob
%   EliminatePriors=0    -- Indicates whether to eliminate the mixtures
%                           with priors less than a certain value...specify
%                           the threshold value here
%   FeatureType='mixed' -- if unknown specified then it will eliminate
%                           cont features from there.  You can specify
%                           binary if only binary features are used to save
%                           time of elimination
%   Model
%    priorP              -- the prior probabilities of each mixture in +ve
%                           examples (mixturesP x 1) matrix
%    probabP            -- the probability vector for each mixture in +ve
%                           examples (mixturesP x TotalFeatures) matrix
%    priorN              -- the prior probabilities of each mixture in -ve
%                           examples (mixturesN x 1)
%    probabN            -- the probability vector for each mixture in -ve
%                           examples (mixturesN x TotalFeatures) matrix
%    PosPriorP          -- the prior of class representing +ve examples
%    NegPriorP          -- the prior of clas representing -ve examples
%
% Methods:
%  train,               -- will get mixture models
%  test                 -- if transformation to prob space is required then
%                           specify 'testGivesProb=1' and test function will 
%                           output the transformed space.  If testing is 
%                           required using mixture models then set
%                           this flag to false.

%    GetLogProb         -- get the log of prob matrix of instances with
%    prob of mixtures
%
% Example:
%
% see example for emGauss but in this case binary features are required
%
%=============================================================================
% Reference : //Reference: H. Li, K. Zhang, and T. Jiang,
% "The regularized EM algorithm", in Proceedings of the 20th National Conference 
% on Artificial Intelligence,2005, pp. 807-812.
%
%=============================================================================

  %<<------hyperparam initialisation------------->>
  a.gamma=0.05
  a.IterationsP=20;
  a.mixturesP=5;    
  a.IterationsN=20;
  a.mixturesN=5;
  a.testGivesProb = 0; 
  a.EliminatePriors = 0;
  a.FeatureType = 'mixed'
  % <<-------------model----------------->> 
  a.PosPrior= 0.5;
  a.NegPrior = 0.5;
 
  a.priorP=[];
  a.probP=[];
  
  a.priorN=[];
  a.probN=[];
  
  
  algoType=algorithm('REMBernoulli');
  a= class(a,'REMBernoulli',algoType);
  
 if nargin==1,
    eval_hyper;
 end;





