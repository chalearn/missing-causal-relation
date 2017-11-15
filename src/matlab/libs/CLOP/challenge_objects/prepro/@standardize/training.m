function [retDat,algo] =  training(algo,retDat)
%[retDat,algo] =  training(algo,retDat)
% Train a standardization preprocessor.
% Inputs:
% algo -- A "standard" classifier object.
% retDat -- A training data object.
% Returns:
% retDat -- Preprocessed data.
% algo -- The parameters of the preprocessing.

% Isabelle Guyon -- September 2005 -- isabelle@clopinet.com

if algo.algorithm.verbosity>0
    disp(['training ' get_name(algo) '... '])
end

X=full(get_x(retDat)); % After this prepro, no matrix is sparse!
retDat=set_x(retDat, X);

if algo.center
    algo.mu = mean(X, 1);
else
    algo.mu = zeros(1, size(X,2));
end
s = std(X,1,1); 
s(find(s==0))=1;
algo.sigma=s;

retDat=test(algo,retDat);

        








