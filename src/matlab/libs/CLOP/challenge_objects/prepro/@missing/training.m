function [retDat,algo] =  training(algo,retDat)
%[retDat,algo] =  training(algo,retDat)
% Train a missing value preprocessor.
% Inputs:
% algo -- A "missing" bject.
% retDat -- A training data object.
% Returns:
% retDat -- Preprocessed data.
% algo -- The parameters of the preprocessing.

% Isabelle Guyon -- February 2009 -- isabelle@clopinet.com

if algo.algorithm.verbosity>0
    disp(['training ' get_name(algo) '... '])
end

X=full(get_x(retDat)); % After this prepro, no matrix is sparse!
retDat=set_x(retDat, X);
[p,n]=size(X);

for k=1:n
    non_missing=find(~isnan(X(:,k)));
    if isempty(non_missing)
        %warning('One column entirely missing');
        algo.median(k)=0;
    else
        algo.median(k)=median(X(non_missing,k), 1);
    end
end

retDat=test(algo,retDat);

        








