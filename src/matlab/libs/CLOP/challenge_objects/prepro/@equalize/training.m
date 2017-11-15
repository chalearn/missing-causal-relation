function [retDat,algo] =  training(algo,retDat)
%[retDat,algo] =  training(algo,retDat)
% Train an equalize preprocessor.
% Inputs:
% algo -- A "equalize" classifier object.
% retDat -- A training data object.
% Returns:
% retDat -- Preprocessed data.
% algo -- The parameters of the preprocessing.

% Isabelle Guyon -- Oct 2012 -- isabelle@clopinet.com

if algo.algorithm.verbosity>0
    disp(['training ' get_name(algo) '... '])
end

X=get_x(retDat);
[algo.xsamp, algo.ysamp]=intersamp(X, algo.knots);

retDat=test(algo,retDat);

        








