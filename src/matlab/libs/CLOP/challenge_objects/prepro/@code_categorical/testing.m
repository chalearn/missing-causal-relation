function dat  =  testing(algo,dat)
%dat =  testing(algo,dat)
% Preprocess categorical variables values.
% Inputs:
% algo -- A "code_categorical" object.
% dat -- A test data object.
% Returns:
% dat -- Preprocessed datalgo.

% Isabelle Guyon -- February 2009 -- isabelle@clopinet.com

if isempty(algo.code_array) return; end

if algo.algorithm.verbosity>0
    disp(['testing ' get_name(algo) '... '])
end

X=get_x(dat); 
X_cate=X(:, algo.cate_idx);
[p,n]=size(X_cate);

fprintf('Finding unique categories in test data\n');
for k=1:n, 
    j=algo.cate_idx(k);
    uval{k}=unique(X(:,j)); 
end

fprintf('Completing with zero the missing code values\n');
% Some codes may be found in test data that are not in training data
for k=1:n,
    A=algo.code_array{k};
    missing_codes=length(A)+1:max(uval{k});
    if all(missing_codes>0)
        A(missing_codes)=0;
        algo.code_array{k}=A;
    end
end

fprintf('Map categories to meaningful numeric values\n');
% Zeros are missing values, they become NaN
zidx=find(X_cate==0);
X_cate(zidx)=NaN;

% Other values
for k=1:n
    A=algo.code_array{k};
    gidx=find(~isnan(X_cate(:,k)));
    X_cate(gidx,k)=A(X_cate(gidx,k));
end

X(:, algo.cate_idx)=X_cate;
dat=set_x(dat, X);

dat=set_name(dat,[get_name(dat) ' -> ' get_name(algo)]); 
  

 