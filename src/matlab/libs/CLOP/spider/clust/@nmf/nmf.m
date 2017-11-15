function a = nmf(hyper) 
% ============================================================================================
% Non-negative Matrix Factorization object
% ============================================================================================
% A=nmf(H) returns a Non-negative Matrix Factorization object.
%
% Given matrix X>0 creates matrices W, H > 0 with X ~ X*=W*H, such that
% the original features X are represented by a new positive basis W and new
% positive features H.  W can be interpreted as components or topics, while H
% are the weights of these components in the original samples.
%
% Usage: [r n]=train(nmf,d);
% Result: r.X = The reduced feature weights, r.Y = original X.  The basis is
%   given in n.H.
%
% Hyperparameters, and their defaults
%
%   N=5; 	            -- number of final basis functions
%   maxIteration=500;   -- maximum number of iterations per cycle
%   nrofrestarts=1;     -- nr of restarts to overcome local minima.
%   eps=1e-3;           -- convergence epsilon (on objective function).
%
% Model
%
%   W  = The (sparse and independant) basis vectors.
%   H  = The reduced feature vectors.
%
% Methods:
%
%   train
%   testing
%
% Example:
%   d=data(abs(rand(20,10)));	% produce random data
%   [r,n]=train(nmf('N=2'),d);	% reduce 10 elements to 2 components
%   reconstructed=(n.W*r.X')';	% component basis * weights
%
% The example is illustrative only, as random data is unlikely to contain any
% meaningful components.
%
% Note: This code is based on Patrik Hoyer's code for simple MSE NMF.
%=============================================================================================
% Reference : Algorithms for Non-negative Matrix Factorization
% Author    : Daniel D. Lee, H. Sebastian Seung
% Link      : http://citeseer.ist.psu.edu/lee00algorithms.html
%=============================================================================================

% hyperparams
a.N=5;

a.maxIteration=500;

a.W=[];
a.H=[];
  
a.eps=1e-3;
a.nrofrestarts=1;

p=algorithm('nmf');
a=class(a,'nmf',p);

% a.algorithm.alias={'W','H','N','nrofrestarts','maxIteration'}; % 

if nargin==1,
  eval_hyper;
end;

