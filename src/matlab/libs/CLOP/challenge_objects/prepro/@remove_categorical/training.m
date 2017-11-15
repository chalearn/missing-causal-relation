function [retDat,algo] =  training(algo,retDat)
%[retDat,algo] =  training(algo,retDat)
% Train a remove_categorical value preprocessor.
% Inputs:
% algo -- A "remove_categorical" object.
% retDat -- A training data object.
% Returns:
% retDat -- Preprocessed datalgo.
% algo -- The parameters of the preprocessing.

% Isabelle Guyon -- February 2009 -- isabelle@clopinet.com

if algo.algorithm.verbosity>0
    disp(['training ' get_name(algo) '... '])
end

X=get_x(retDat);
Y=get_y(retDat); 
[p,n]=size(X);
ncat=length(algo.cate_idx);

fprintf('Finding unique categories\n');

if ~ncat
    fprintf('Detecting categorical variables based abscence of NaN and on number of unique values\n');
    gidx=setdiff(1:n, find(any(isnan(X))));
    Xg=X(:,gidx);
    ng=size(Xg,2);
    L=[];
    for k=1:ng, uval{k}=unique(Xg(:,k)); end
    for k=1:ng, L(k)=length(uval{k}); end
    cate_idx=find(L<p/3);
    uval=uval(cate_idx);
    ncat=length(cate_idx);
    algo.cate_idx=gidx(cate_idx);
end
fprintf('Found %d categorical variables to be removed\n', ncat);

retDat=test(algo,retDat);

        








