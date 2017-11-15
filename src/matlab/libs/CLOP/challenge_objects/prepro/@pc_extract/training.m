function [dat,algo] =  training(algo,dat)
%[dat,algo] =  training(algo,dat)
% Train a principal component analysis feature construction preprocessor.
% Inputs:
% algo -- A "pc_extract" learning object.
% dat -- A training data object.
% Returns:
% dat -- Preprocessed data.
% algo -- The principal components, etc.

% Isabelle Guyon -- September 2005 -- isabelle@clopinet.com

if algo.algorithm.verbosity>0
    disp(['training ' get_name(algo) '... '])
end

X=get_x(dat);
[p,n]=size(X);

% Center the data
algo.mu=mean(X,1);
X=full(X)-algo.mu(ones(p,1),:);

% Use singular value decomposition
[XN,S,V] = svd(X, 'econ');
S=diag(S);

pc=length(find(S~=0));
algo.f_max=min(algo.f_max, pc); 
pc=algo.f_max;

dat=set_x(dat, XN(:,1:pc));
S=S(1:pc);

algo.W=S;
algo.U=V(:,1:pc)*diag(1./S);

dat=set_name(dat,[get_name(dat) ' -> ' get_name(algo)]); 

        








