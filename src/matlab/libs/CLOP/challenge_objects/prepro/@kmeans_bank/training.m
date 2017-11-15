function [retDat,algo] =  training(algo,retDat)
%[retDat,algo] =  training(algo,retDat)
% Train a pca bank.
% Inputs:
% algo -- A data object to be "trained".
% retDat -- A training data object.
% Returns:
% retDat -- No data modification.
% algo -- The trained filter bank.

% Isabelle Guyon -- November 2005 -- isabelle@clopinet.com

[XN, km]=train(kmeans({['k=' num2str(algo.f_max)]}), retDat);

algo.data.X=km.mu;

        








