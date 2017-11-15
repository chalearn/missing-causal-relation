function a = neural(hyper) 
%=============================================================================
% NEURAL network object (interface to NETLAB)             
%=============================================================================  
% a=neural(hyperParam) 
%
% Generates a Neural Network classication object 
%   Hyperparameters
%   units               -- number of trees
%   shrinkage                 -- number of candidate feature per split
%   maxiter               -- number of iterations
%
%   Model
%    net                  -- network structure
%
% Methods:
%  train, test, default
%
% Example:
%
% [r a]=train(neural,toy2d);
%
%=============================================================================
% Reference :   Neural Networks for Pattern Recognition (Bishop, 1995)
% Code: NETLAB, Ian Nabney (i.t.nabney@aston.ac.uk) or Christopher Bishop (c.m.bishop@aston.ac.uk).
%=============================================================================

a.IamCLOP=1;

% <<------Display only "public" data members ------------->> 
a.display_fields={'units', 'shrinkage', 'balance', 'maxiter'};
% <<------hyperparam initialisation------------->> 
a.units=    default(10, [0 Inf]);       % number of hidden units
a.balance=  default(0, {0, 1});         % enforce class balancing
a.shrinkage=default(1e-14, [0 Inf]);    % shrinkage is a scalar, inverse variance of a zero-mean isotropic Gaussian prior.
                                        % that is basically a weight decay regularization, or a ridge.
a.maxiter=  default(100, [0 Inf]);       % maximum number of iterations
  
% <<-------------model----------------->> 
a.net=[];           
a.itnum=0;
a.options=[];

algoType=algorithm('neural');
a= class(a,'neural',algoType);

a.algorithm.do_not_evaluate_training_error=0; 
a.algorithm.use_signed_output=0; % Return the discriminant values
a.algorithm.verbosity=1;

eval_hyper;