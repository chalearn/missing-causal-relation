function [retDat,algo] =  training(algo,retDat)
%[retDat,algo] =  training(algo,retDat)
% Train a scale preprocessor.
% Inputs:
% algo -- A "scale" classifier object.
% retDat -- A training data object.
% Returns:
% retDat -- Preprocessed data.
% algo -- The parameters of the preprocessing.

% Isabelle Guyon -- September 2005 -- isabelle@clopinet.com

if algo.algorithm.verbosity>0
    disp(['training ' get_name(algo) '... '])
end

X=get_x(retDat);
if isempty(algo.offset)
    algo.offset=min(min(X));
end
if isempty(algo.factor)
    algo.factor=max(max(X))-algo.offset;
end

retDat=test(algo,retDat);

        








