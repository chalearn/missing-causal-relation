function a = prune(C,hyper)

%  PRUNE
%
% A=PRUNE(H) Prune object with hyperparameters H
% A=PRUNE(C,H) returns a Prune object initialized with weak
% learning algorithm of type C and hyperparameters H.
%
% This algorithm removes from the training data the samples
% of the negative class corresponding to features always negative
% for the positive class (negative features). 
% It then trains a classifier of type C.
% At test time, it classifies as negative the examples having
% at least one of the negative features positive. The remaining
% examples are classified by the trained classifier.
% 
% Hyperparameters, and their defaults
% child   = lssvm           -- classifier used (if not specified as first argument)
% tol     = 0               -- tolerance of error for the pruned patterns
% p_min   = []              -- minimum number of patterns to train on
%
% Methods:
%  train, test
%
% Model:
%  child                  -- learning algorithm
%
% Example:
%
% X=[1+0.1*rand(5,5); -1+0.1*rand(5,5)];
% X=[[zeros(8,1);ones(2,1)], X, [zeros(7,1);ones(2,1);0]];
% Y=[ones(5,1);-ones(5,1)];
%
% [r,a]=train(prune(naive),data(X,Y));

% ========================================================================
% Reference : Gavin Cawley, WCCI/IJCNN 2006 challenge.
% http://clopinet.com/isabelle/Projects/modelselect/Papers/Cawley_paper_IJCNN06.pdf
% ========================================================================
% Wriiten by: Isabelle Guyon , isabelle@clopinet.com , Sept. 2006
% ========================================================================

a.IamCLOP=1;

% Public HP:
a.display_fields    = {'tol', 'p_min'};
a.child             = lssvm; % default classifier.
a.tol               = default(0, [0, 1]);
a.p_min             = default([], [0, Inf]);

% Model:
a.negfeat           = [];    % Indices of "negative" features.
a.posfeat           = [];    % Indices of the other features.

% parse the arguments
if nargin>0 
    if ~isobject(C)       
        hyper=C;
    else
        a.child=C; 
    end
end

p   = algorithm('prune');
a   = class(a,'prune',p);
a.algorithm.use_signed_output   = 0;

eval_hyper;
