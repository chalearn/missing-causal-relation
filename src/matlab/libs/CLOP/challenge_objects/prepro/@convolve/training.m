function [retDat,algo] =  training(algo,retDat)
%[retDat,algo] =  training(algo,retDat)
% Train a convolutional preprocessor.
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

X=full(get_x(retDat)); % After this prepro, no matrix is sparse!
retDat=set_x(retDat, X);

% No training
retDat=test(algo,retDat);

        








