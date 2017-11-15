function a = hmm(hyper)   
%=============================================================================     
% Hidden markov model - for learning time dependend structures  
%=============================================================================    
%  
% A=HMM(H) returns a hidden markov model object. Its based on code from a
% lecture of Sam Roweis.
%
% The data is assumed to be cell arrays or a matrix with positive numbers
% as entries and zeros, where there is no sequence entry. 
% 
% Example:
% These representations are equivalent:
%
% Y{1} = [1,2,3,1,4,1]
% Y{2} = [1,1,1,3]
%                       and
%
% Y = [1,2,3,1,4,1;1,1,1,3,0,0]
% 
% The testing methode computes the most probable sequence of states for
% given symbol sequence and its loglikelihood.
%
% Hyperparameters, and their defaults   
%   alpha = [] -- indices which refer to cell array components, that are
%                    the charakters of the alphabet.
%                    The training sequnces have to be vectors of indices.
%   
%   tol = 1e-5     -- convergence criterion. fractional change of loglokelihood, 
%                     which stops the iteration
%
%   A = 2          -- number of states or the transition probabilities
%   updateflags = [1,1,1]    -- controls the update of parameters
%                               it is a three-vector whose elements
%                               control the updating of [A,pi,B] 
%                               nonzero elements mean update that parameter
%   testing_mode=0  Determines the testing mode. testing_mode=0 
%                           estimates the most probable path with their loglikelihoods 
%                           given the sequences. testing_mode=1 generates
%                           sequences with the model. In this case the data
%                           object passed to the hmm should be d([m,l]),
%                           where m is the number of training sequences to
%                           be generated and l is the length of the
%                           sequences
%
%   maxiter = 100  -- maximal number of iterations for EM-algorithm
%
% Model  
%
%   alpha.Y   -- observation emission probabilities
%   alpha.X   -- state transition probabilities
%   pi  -- initial state prior probabilities
%   LL  -- log likelihood curve
%   M   -- number of symbols
%
%  Methods:  
%  train, test
%
%  Example: % simulating fair/unfair dice
% %  prob distributions for fair and unfair die
%  unfair = [1,1,1,1,100,100]; unfair = unfair/sum(unfair);
%  fair = [1,1,1,1,1,1]; fair = fair/sum(fair);
%  
%  max_l = 30; % maximum sequence length
%  X  = []; stay_prob = 0.9; % probability to stay in the same state
%  for i = 1:200 % generate 100 sequences
%      l = round(rand*10)+1;
%      fairdice = 1; % we start with the fair dice
%      pi = []; seq = [];  
%      for j = 1:l
%              tmp = rand;
%              if fairdice
%                      for k = 1:length(fair), if tmp < sum(fair(1:k)), break;  end , end
%                      seq = [seq,k];
%                      % change dice?
%                      if rand > stay_prob,  fairdice = 0;  end
%              else
%                      for k = 1:length(unfair), if tmp < sum(unfair(1:k)),break; end , end
%                      seq = [seq,k];
%                      % change dice?
%                      if rand > stay_prob,  fairdice = 1;   ,  end
%              end
%      end
%      X = [X; seq , zeros(1,max_l+1-size(seq,2))];
%  end
%  d = data(X);
%  [r a] = train(hmm,d)
%
%
%   WARNING: If you get errors, it may be due to the fact, that data object
%   in spider are not suited to store cell arrays.
%
%
%=============================================================================   
% Reference  : A tutorial on Hidden Markov Models and Selected Applications in Speech Recognition
% Author     : Lawrence R. Rabiner
% Link       : http://www.ai.mit.edu/~murphyk/Bayes/rabiner.pdf
%=============================================================================
    
%hyperparams  



  a.M = 1;
  a.pi = [];
  a.alpha = [];
  a.A = 2;
  a.B = [];
  a.maxiter = 100;
  a.tol = 1e-5;
  a.updateflags = [];
  a.LL = [];
  a.testing_mode = 0;
  
  p=algorithm('hmm'); p.use_signed_output=0;  
  a= class(a,'hmm',p);  
   
  if nargin==1,  
    eval_hyper;  
  end;  
