function a = rank_perceptron(Yset,exYsets,hyper)   
%============================================================================
% Ranking Perceptron by Collins et al.
%=============================================================================  
% a=rank_perceptron(hyperParam,Yset,exYsets) 
% 
% Generates a Ranking Perceptron object with given hyperparameters.
%
% The rank perceptron uses a joint kernel on the inputs and outputs.
% Labeled data are given of the form (x_i,y_i) which specify a map from
% x_i -> y_i. Essentially, the data (x_i y_i) are considered positive examples
% given to a classifier and every other output y \in Yset is considered as 
% a negative example. Training consists of finding tuning the parameters alpha
% such that  y_i = argmax_y ( f(x_i,y))  for all i, i.e. the correct map is learnt
% for the training data. Here, f(x,y) = \sum \alpha_i J((x_i,x_i,),(x,y))
% is a measure of match between input x and output y.
%
% One thus must give as input the set Yset, and the choice of joint kernel,
% can currently be a product of 'linear', 'poly' or 'rbf' between inputs 
% and outputs.
% Outputs y_i are given in the form of indices into the set Yset.
%
%
%   Hyperparameters (with defaults)
%   kertype='linear'     -- the kernel type, either 'linear','poly' or 'rbf' on the inputs.
%                           kernel is always linear on the outputs (enables fast pre-images) 
%   kerparam=1;          -- kernel parameter (for 'poly' or 'rbf' kernel)
%   loops=100            -- number of iterations of training
%   Yset=[];             -- set of possible outputs to choose from
%   exYsets=[];          -- If exYsets is nonempty there is a different set
%                           of outputs exYsets{i} for each training pair (x_i,y_i). 
%                           exYsets{i} is a vector which indexes into Yset.
%                           In the testing phase, the output is selected
%                           from the set a.exdbase which must be changed in the
%                           algorithms model parameters, per test example (no longer a cell).
%
%
%   output_preimage=0    -- whether to output y given x  or index into Yset (default)
% 
%   Model 
%    alpha               -- the weights
%    svs                 -- the support vectors
%    dat                 -- the original data
%    dbase               -- the set of all possible Ys (outputs)  
%    exdbase             -- the set of possible outputs for each example (a cell) 
% 
% Methods: 
%  train, test
%
% Example:
%   d=gen(toy); d.Y(d.Y==1,:)=1; d.Y(d.Y==-1,:)=2;
%   a=rank_perceptron([1 0 0; 0 1 0  ;0 0 1]);
%   [r a]=train(a,d);
%
%   d=gen(toy); d.Y(d.Y==1,:)=1; d.Y(d.Y==-1,:)=2;
%   for i=1:50 dbs{i}=[1 2 3]; end;
%   a=rank_perceptron([1 0 0; 0 1 0  ;0 0 1],dbs);
%   [r a]=train(a,d);
%
%=============================================================================
% Reference : New Ranking Algorithms for Parsing and Tagging: Kernels over Discrete Structures and the Voted Perceptron
% Author    : Michael Collins and Nigel Duffy
% Link      : http://www.ai.mit.edu/people/mcollins/papers/finalacl2002.ps
%=============================================================================


  
  % model 
  a.loops=100;
  a.alpha=[];
  a.svs=[];
  a.dat=[]; 
  a.dbase=Yset;  
  a.exdbase=[];
  if nargin>1
   a.exdbase=exYsets;
  end
  a.output_preimage=0;
  a.dtrain=[];
  a.kertype='linear'; 
  a.kerparam=1;
  
 
  
  p=algorithm('rank_perceptron');
  a= class(a,'rank_perceptron',p);
 
  if nargin==3,
    eval_hyper;
  end;
