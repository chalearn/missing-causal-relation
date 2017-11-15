function a = remAll(in,hyper) 
%=============================================================================
% Expectation maximization object for learning bernoulli mixtures (regularized version)             
% for binary data and learning gaussian mixtures for cont data 
% written by Mehreen Saeed 08 June, 2007. FAST National University of Computer
%   and Emerging Sciences   Pakistan mehreen.saeed@nu.edu.pk ;
%   mehreen.mehreen@gmail.com
%=============================================================================  
% a=em(hyperParam) 
%
% Generates an em object for guassian mixture models with given hyperparameters.
% IMPORTANT the covariance matrices are diagonal cov. matrices
%
%   Hyperparameters (with defaults)
%   testGivesProb     -- indicates whether test routine should return prob
% Models
%   bernoulli         -- rem model for bernoulli
%   gauss             -- em model for gaussian dist 
% Methods:
%  train,               -- will get mixture models
%  test                 -- if transformation to prob space is required then
%                           specify 'testGivesProb=1' and test function will 
%                           output the transformed space.  If testing is 
%                           required using mixture models then set
%                           this flag to false.
%    GetLogProb         -- get the log of prob matrix of instances with
%                           prob of mixtures
%
% Example:
%
% see example for emGauss but continous + binary features data is required
%
%=============================================================================
% Reference :
% Reference : //Reference: H. Li, K. Zhang, and T. Jiang,
% "The regularized EM algorithm", in Proceedings of the 20th National Conference 
% on Artificial Intelligence,2005, pp. 807-812....for bernoulli mixtures
% and Ethem Alpaydin "Introduction to machine learning", 2005 for Gauss
% mixtures
%=============================================================================

  %<<------hyperparam initialisation------------->> 
  a.testGivesProb = 0; 
  a.bernoulli = REMBernoulli;
  a.gauss = emGauss;
  
 if nargin == 0, in = {}; 
 end
  
  a.child={};
  if ~iscell(in)       
    if ischar(in)
        % The first argument is in fact a hyperparameter string
        hyper=in;
    else
        % The first argument is a single learning object
        a.child{1}=in; 
    end
  else
    % determine whether a hyperparameter array is passed
    hp=0;
    for k=1:length(in)
        if ischar(in{k})
            hp=1;
        end
    end
    if hp
        hyper=in;
    else
        a.child=in; 
    end
  end
 
  % <<-------------model----------------->> 
  
  for k=1:length(in)
        if isa(in{k},'emGauss')
            a.gauss = in{k};
        elseif isa(in{k},'REMBernoulli')
                a.bernoulli = in{k};
        end
 end
    
  algoType=algorithm('remAll');
  a= class(a,'remAll',algoType);
  
 eval_hyper;
