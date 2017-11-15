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

X=get_x(retDat);

% Center the data
%[p,n]=size(X);
%mu=mean(X,1);
%X=full(X)-mu(ones(p,1),:);

% Use singular value decomposition
[XN,S,V] = svd(X, 'econ');
S=diag(S);

pc=length(find(S~=0));
algo.f_max=min(algo.f_max, pc); 
pc=algo.f_max;
algo.data.X=V(:,1:pc)';

        








