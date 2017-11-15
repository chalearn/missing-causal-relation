
function a = rf(hyper) 
%=============================================================================
% RF Random Forest object             
%=============================================================================  
% a=rf(hyperParam) 
%
% Generates a Random Forest classication object 
%   Hyperparameters
%   units               -- number of trees
%   mtry                -- number of candidate feature per split
%
%   Model
%    forest             -- the forest structure
%
% Methods:
%  train, test, print, guess
%
% Example:
%
% [r a]=train(rf,toy2d);
%
%=============================================================================
% Reference :   Random Forests, Leo Breiman, Machine Learning, 
%               45(1), pp 5--32, Kluwer Academic, 2001
% Code: Interface to the Matlab interface of Ting Wang,   Merck & Co.
% based on Breiman and Cutler's original Fortran code version 3.3
%=============================================================================

% <<------Display only "public" data members ------------->> 
a.display_fields={'units', 'mtry', 'balance'};

% <<------HP init: default or (default, [min, max]) or (default, {choices}) ------------->> 
a.units=  default(100, [0 Inf]);
a.mtry=   default([], [0 Inf]);
a.balance=default(0, {0, 1});

% <<------ Private data members (insufficiently tested) ------------->> 
a.IamCLOP=1;
a.optimizer='R'; % Other possibilities: 'Weka', 'Merk'

% <<-------------model----------------->> 
a.forest=[];           
a.targets=[];
a.param=[];

algoType=algorithm('rf');
a= class(a,'rf',algoType);

a.algorithm.do_not_evaluate_training_error=0; 
a.algorithm.use_signed_output=0; % Return the discriminant values
a.algorithm.verbosity=1;

eval_hyper;

 

 
 





