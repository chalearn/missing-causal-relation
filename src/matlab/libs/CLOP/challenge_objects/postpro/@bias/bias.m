function a = bias(hyper) 
%=============================================================================
% BIAS postprocessor object             
%=============================================================================  
% a=bias(hyperParam) 
%
% Generates a Bias object to post-fit the bias.
%
% Hyperparameter:
%   option              -- Type of bias optimization
%   1: minimum of the BER 
%   2: break-even-point between sensitivity and specificity
%   3: average of the two previous results if they do not differ a lot, otherwise zero.
%   4: values that gives the same fraction of positive responses on the
%   test data than on the training data (transduction).
%
%   Model
%    b0                  -- the bias
%
% Methods:
%  train, test, default
%
%=============================================================================
% Author of code: Isabelle Guyon -- isabelle@clopinet.com -- February 2006
%=============================================================================

a.IamCLOP=1;

% <<------hyperparam initialisation------------->> 
a.display_fields = {'option'};
a.option = default(1, {1, 2, 3, 4});

% <<-------------model----------------->> 
a.b0=0;
a.fpos=[]; % fraction of examples of the positive class

algoType=algorithm('bias');
a= class(a,'bias',algoType);

a.algorithm.do_not_evaluate_training_error=0; 
a.algorithm.use_signed_output=0; % Return the discriminant values
a.algorithm.verbosity=1;

% there are no hyperparameters
eval_hyper;