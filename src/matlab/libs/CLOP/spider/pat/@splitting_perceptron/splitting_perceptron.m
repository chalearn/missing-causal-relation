function a = splitting_perceptron(Yset,hyper)   
%=============================================================================
% Splitting Perceptron 
%=============================================================================  
% a=splitting_perceptron(hyperParam) 
% 
% Generates a Splitting Perceptron (SP) object with given hyperparameters.
%
% The splitting perceptron algorithm tries to separate the first r
% (best) candidates from the last k (worst) of a given set of
% candidates for a (not specified) example with a discriminative function 
% f(x) = <w,x>. 
% The set of training candidates is assumed to be sorted in non-decreasing order 
% accoring to their quality.
%
% As the number of candidates for each example might be large, the training
% data is given as follows: 
% X stores m times the base name (including path) of the files containing
% the candidates. The actual files have a number which conincides with
% the label Y. E.g. if X(i,:) = '../data/candidate', the corresponding
% file would be ['../data/candidate' num2str(Y(i)) '.mat']. The name of the
% variable in the file holding the feature vectors of the
% candidates as row vectors is assumed to be "X".
% ATTENTION: You have to give a name to your datasets as the first
% parameter is interpreted as a name due to spider specification. If you do
% not name your dataset spider will interpret the filenames as name of the
% dataset.
%
% Hyperparameters (with defaults)
% r=1                  -- rank to which the candidates are considered
%                           best
% k=1                  -- number of last ranks for which the candidates
%                           are assumed to be worst (i.e. the last n-k candidates)
% tau=1                -- margin by which the candidates shall be
%                         separated
% loops=100            -- maximal number of iterations of training
% 
%
% Model 
%  alpha               -- the weights
% Methods:
%  train, test
%
% Example:
% % Say you have 100 files with candidates in ../demos/data/toy_candidate with 
% % core name "candidate"
% X = repmat(['../demos/data/toy_candidate/candidate'],100,1);
% d = data('training',X,[1:100]')
% a = splitting_perceptron
% a.r = 30; a.k = 30; a.tau = 20;
% [r a]=train(a,d);
%
%=============================================================================
% Reference : Discriminative Reranking for Machine Translation
% Author    : Libin Shen, Anoop Sarkar and Franz Josef Och
% Link      : http://www.sfu.ca/~anoop/papers/pdf/drmt.pdf
%=============================================================================


  
  % model 
  a.loops=100;
  a.alpha=[];
  a.r = 1;
  a.k = 1;
  a.tau = 1;
  
  p=algorithm('splitting_perceptron');
  a= class(a,'splitting_perceptron',p);
 
  if nargin==2,
    eval_hyper;
  end;
