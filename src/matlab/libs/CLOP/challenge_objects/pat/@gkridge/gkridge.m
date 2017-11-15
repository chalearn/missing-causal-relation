
function a = gkridge(hyper) 
   
% GKRIDGE template object 
% AUTHOR:  Gavin Cawley, gcc@cmp.uea.ac.uk
%  
% A=GKRIDGE(H) returns a generalized kernel ridge regression object
% initialized with hyperparameters H. 
%
% Hyperparameters, and their defaults
%  None so far.
%
% Methods:
%  train, test 
% 
% Example: 
%   example(gkridge)
% ========================================================================
% Reference  : 
% G. C. Cawley, G. J. Janacek, and N. L. C. Talbot. Generalised kernel machines. In Proceedings of the
% IEEE/INNS International Joint Conference on Neural Networks (IJCNN-07), pages 1732–1737, Orlando,
% Florida, USA, August 12–17 2007.
%=========================================================================

% <<------hyperparam initialisation------------->> 
a.display_fields={};

% <<------ Private data members ------------->> 
a.IamCLOP=1;

% <<-------------model----------------->> 
a.gkm      = krr;
a.selector = simplex('criterion', sse);

algoType=algorithm('gkridge');
a= class(a,'gkridge',algoType);

a.algorithm.do_not_evaluate_training_error=0; 
a.algorithm.use_signed_output=0; % Return the discriminant values
a.algorithm.verbosity=1;

% no hyper parameters so far!
%eval_hyper;
 