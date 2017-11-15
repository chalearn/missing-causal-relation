function [retDat,algo] =  training(algo,retDat)
%[retDat,algo] =  training(algo,retDat)
% Preprocessing by line normalization.
% Inputs:
% algo -- A "normalize" object.
% retDat -- A training data object.
% Returns:
% retDat -- Preprocessed data.
% algo -- The "normalize" object again.

% Isabelle Guyon -- September 2005 -- isabelle@clopinet.com

if algo.algorithm.verbosity>0
    disp(['training ' get_name(algo) '... '])
end

% No training actually!
retDat=test(algo,retDat);

        








