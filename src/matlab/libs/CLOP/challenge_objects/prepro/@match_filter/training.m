function [retDat,algo] =  training(algo,retDat)
%[retDat,algo] =  training(algo,retDat)
% Train a match filter preprocessor.
% Inputs:
% algo -- A "standard" classifier object.
% retDat -- A training data object.
% Returns:
% retDat -- Preprocessed data.
% algo -- The parameters of the preprocessing.

% Isabelle Guyon -- November 2005 -- isabelle@clopinet.com

if algo.algorithm.verbosity>0
    disp(['training ' get_name(algo) '... '])
end

% Train the filter bank
[retDat, algo.child]=train(algo.child, retDat);

retDat=test(algo,retDat);

        








