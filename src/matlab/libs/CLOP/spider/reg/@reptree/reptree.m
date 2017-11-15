function a = reptree(hyper)
%=============================================================================
% Reduced Error Pruning tree object
%=============================================================================
% a0=reptree(hyperParam)
%
% Generates a Reduced Error Pruning wrapper on the WEKA RepTree implementation with given hyperparameters.
% Weka Code by Eibe Frank.
%
%   Hyperparameters (with defaults)
%   minleaf       Set minimum number of instances per leaf (default 2).
%   minvar      Set minimum numeric class variance proportion of train
%               variance for split (default 1e-3).
%   folds       Number of folds for reduced error pruning (default 3).
%   seed        Seed for random data shuffling (default 1).
%   pruning     pruning Yes or No  (default=0 -- No).
%   maxdepth    Maximum tree depth (default -1, no maximum). 
%
%   Model
%    tree               -- the tree
%    feats              -- used features
%
% Methods:
%  train, test, disp
%
% Example:
%
% d=gen(toyreg({'o=1','nonlinear=1'}))
% d.Y=(d.X-1).^3;
% [r,a]=train(reptree,d);
% clf;
% plot(d.X,r.Y,'b.'), hold on , plot(d.X,r.X,'r.')
% 
%=============================================================================
% Reference : ?
% Author    : ?
% Link      :http://weka.sourceforge.net/doc/
%=============================================================================


%parameters

a.minleaf=2;
a.minvar=1e-3;
a.folds=3;
a.seed=1;
a.pruning=0;
a.maxdepth=-1;

%model
a.tree=[];
a.feats=[];


p=algorithm('reptree');
a= class(a,'reptree',p);

if nargin==1,
    eval_hyper;
end;

a.algorithm.use_signed_output=0;