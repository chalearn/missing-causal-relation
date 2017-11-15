function dat  =  testing(algo,dat)
%dat =  testing(algo,dat)
% Preprocess missing values.
% Inputs:
% algo -- A "missing" object.
% dat -- A test data object.
% Returns:
% dat -- Preprocessed data.

% Isabelle Guyon -- February 2009 -- isabelle@clopinet.com

if isempty(algo.median) return; end

if algo.algorithm.verbosity>0
    disp(['testing ' get_name(algo) '... '])
end

X=get_x(dat); 
[p,n]=size(X);

for k=1:n
    missing=find(isnan(X(:,k)));
    X(missing,k)=algo.median(k);
end

dat=set_x(dat, X);

dat=set_name(dat,[get_name(dat) ' -> ' get_name(algo)]); 
  

 