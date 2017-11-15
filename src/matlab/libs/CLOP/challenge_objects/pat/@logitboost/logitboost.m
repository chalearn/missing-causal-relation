
function a = logitboost(hyper) 
%=============================================================================
% LB Logitboost object             
%=============================================================================  
% a=logitboost(hyperParam) 
%
% Generates a Logitboost classication object 
%   Hyperparameters
%   units               -- Number of weak learners (trees)
%                          This number can be changed (made smaller) after
%                          training, with a.units=xxx;
%   shrinkage           -- Shrinkage parameter
%
%   Model
%    lb                 -- The logitboost structure (the structure is saved
%                           to file in R format)
%
% Methods:
%  train, test
%
% Example:
%
% [r a]=train(rf,toy2d);
%
%=============================================================================
% Reference :   Logitboost implementation by Roman Lutz, 2006
%=============================================================================

% <<------Display only "public" data members ------------->> 
a.display_fields={'units', 'shrinkage', 'depth'};

% <<------HP init: default or (default, [min, max]) or (default, {choices}) ------------->> 
a.units=       default(50, [0 Inf]);
a.shrinkage=   default(0.3, [0 Inf]);
a.depth=       default(1, [0 Inf]);      % Maximum tree depth

% <<------ Private data members ------------->> 
a.IamCLOP=1;
a.train=0;      % Performs effectively no training to save memory, just saves the data
a.zmax=10;      % Maximum z value
a.graphic=0;    % 0/1 flag to enable R graphic for debug
a.nboost=[];    % Number of boosting iterations (equal to a.units, unless the 
                % number of units is changed after training
a.input_type=0; % 0 for 0/1, 1 for +-1

% <<-------------model----------------->> 
a.lb=[];           

algoType=algorithm('logitboost');
a= class(a,'logitboost',algoType);

if a.train==0
    a.algorithm.do_not_evaluate_training_error=1; 
    % Avoids testing (saves time) -- Memorization  of training data, 
    % training error = 0
else
    a.algorithm.do_not_evaluate_training_error=0; 
end
a.algorithm.use_signed_output=0; % Return the discriminant values
a.algorithm.verbosity=1;

eval_hyper;

 

 
 





