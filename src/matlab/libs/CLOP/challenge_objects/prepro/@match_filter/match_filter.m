
function a = match_filter(hyper) 
%=============================================================================
% MATCH_FILTER object for preprocessing by match filtering with a filter bank           
%=============================================================================  
% a=match_filter(hyperParam) 
%
% Performs a dot product with each element of a filter bank.
% The filter bank is passed as a child.
% This assumes 2 d image filtering.
%
%   Hyperparameter:
%   child              -- a filter bank object.
%
% Methods:
%  train, test 
%=============================================================================
% Author of code: Isabelle Guyon -- isabelle@clopinet.com -- November 2005
%=============================================================================

% <<------hyperparam initialisation------------->> 
if nargin<1, 
    a.child=hadamard_bank;
else
    a.child=hyper;
end

algoType=algorithm('match_filter');
a= class(a,'match_filter',algoType);

a.algorithm.verbosity=1;












