function a = randomforest(hyper)
%=============================================================================
% Random Forest Decision Tree  by L.Breiman  [WEKA Required]
%=============================================================================
% Original WEKA Code from Richard Kirkby
% Please see WEKA: http://www.cs.waikato.ac.nz/ml/weka/
%
% Generates a random forest wrapper on the WEKA Random Forest implementation with given hyperparameters.
%
%
%   Hyperparameters (with defaults)
%   numoftrees=10      -- set to number of trees
%   numoffeatures=0  -- number of features considered. 0 means use all, -1
%   use only log Nmax features (Nmax equals input dimension)
% 
%   seed=0           -- used seed
%  Model
%    tree               -- the tree
%
% Methods:
%  train, test, plot 
%  
% Example:
%d=gen(toy2d('2circles','l=200'));
%r0=randomforest;
%[cr,ca]=train(cv(r0),d); loss(cr), pause
%[r,a]=train(s0,d);
%disp('probability output'), plot(a,d), pause,
%=============================================================================
% Reference : 
% Author    :   
% Link      : 
%=============================================================================


%parameters
a.numoftrees=10;
a.numoffeatures=0;
a.seed=1;
%model
a.tree=[];



p=algorithm('randomforest');
a= class(a,'randomforest',p);

if nargin==1,
    eval_hyper;
end;
