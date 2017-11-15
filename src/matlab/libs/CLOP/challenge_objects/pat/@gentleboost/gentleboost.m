function a = gentleboost(C,hyper)

%  GENTLEBOOST
%
% A=GENTLEBOOST(H) Gentleboost object with hyperparameters H
% A=GENTLEBOOST(C,H) returns a GentleBoost object initialized with weak
% learning algorithms of type C and hyperparameters H.
%
% Currently, in each iteration of boosting, this algorithm uses subsampling
% of the original data, according to the weights distribution over the
% examples.
% 
% Hyperparameters, and their defaults
% child = neural          -- weak learner (if not specified as first argument)
% units = 5               -- number of weak learners
% balance = 1             -- set one to balance the pos/neg number of
%                            examples
% subratio = 0.9          -- subsampling ratio, compared to number of
%                            examples
% rejNum = 3              -- how many times try a new weak classifier after
%                            rejection, when weighted error rate is above 
%                            0.5 before stopping the boosting loop.
%
% Methods:
%  train, test
%
% Model:
%  child                  -- learning algorithm
% Example:
%
% % Use gentleboost with 1-knn as weak learner and validate with 2 fold cross validation.
% c1=[2,0];
% c2=[-2,0];
% X1=randn(50,2)+repmat(c1,50,1);
% X2=randn(50,2)+repmat(c2,50,1);
%
% d=data([X1;X2],[ones(50,1);-ones(50,1)]);
% [r,a]=train(cv(gentleboost(knn),'folds=2'),d);
%
% ========================================================================
% Reference : H Friedman, T Hastie, R Tibshirani, Additive logistic
% regression: a statistical view of boosting. Ann. Statist, 28, no. 2
% (2000), 337–407.
% http://projecteuclid.org/Dienst/UI/1.0/Summarize/euclid.aos/1016218223
% ========================================================================
% Amir R. Saffari , amir@ymer.org , Jan. 2006
% ========================================================================

% IG: Constructor modified to support Spider syntax backward compatibility.

a.IamCLOP=1;

% Public HP:
a.display_fields    = {'units', 'balance', 'subratio', 'rejNum'};
a.units         = default(5, [0, Inf]);
a.balance       = default(1, {0, 1});
a.subratio      = default(0.9, [0,1]);
a.rejNum        = default(3, [0, Inf]);
a.child         = neural; % default weak learner.

% Private HP:
a.takeHypeTan   = 0;
a.rej           = 1;
a.alpha         = [];

% parse the arguments
if nargin>0 
    if ~isobject(C)       
        hyper=C;
    else
        a.child=C; 
    end
end

p   = algorithm('gentleboost');
a   = class(a,'gentleboost',p);
a.algorithm.use_signed_output   = 0;

eval_hyper;

% Replicate the weak learner
C=a.child;
a.child={};
for i = 1:a.units
    a.child{i}  = C;
end
% Initialize the alphas
a.alpha         = ones(a.units,1)/a.units;