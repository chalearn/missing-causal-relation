function a = squash(hyper) 
%=============================================================================
% SQUASH postprocessor object             
%=============================================================================  
% a=squash(hyperParam) 
%
% Generates a Squash object to post-fit the outputs.
% y = s * tanh(W x + b0) +y0
% This takes unidimensional vectors as inputs
%
% Hyperparameter:
% eta       -- learning rate
% maxiter   -- maximum number of iterations
%
%   Model
%    w                   -- weight
%    b0                  -- bias
%
% Methods:
%  train, test, default
% x=randn(100, 1);
% y=0.5*tanh(3*x+2)+0.1;
% y=0.5*tanh(3*x+2)+0.1*randn(100, 1)-1;
% y=2*tanh(0.5*x+2)+0.1*randn(100, 1)-1;
% x=rand(100, 1);
% y=5*tanh(x-1)+0.1*randn(100, 1)+1;
% y=0.02*tanh(-7*x-2)+12;
% d=data(x, y);
% [dd, mm]=train(squash, d);
%
%=============================================================================
% Author of code: Isabelle Guyon -- isabelle@clopinet.com -- April 2013
%=============================================================================

a.IamCLOP=1;

% <<------hyperparam initialisation------------->> 
a.display_fields = {'eta', 'maxiter', 'gamma', 'diff', 'tol' 'smin'};
a.eta = 0.01;
a.maxiter = 5000;
a.gamma=0.1; % weight decay
a.diff=1e-2; % percent progress
a.tol=1e-4; % tolerance of error
a.smin=0.01;

% <<-------------model----------------->> 
a.b0=0;
a.W=1; % model weight
a.s=1;
a.y0=0;

algoType=algorithm('squash');
a= class(a,'squash',algoType);

a.algorithm.do_not_evaluate_training_error=0; 
a.algorithm.use_signed_output=0; % Return the discriminant values
a.algorithm.verbosity=1;

% there are no hyperparameters
eval_hyper;