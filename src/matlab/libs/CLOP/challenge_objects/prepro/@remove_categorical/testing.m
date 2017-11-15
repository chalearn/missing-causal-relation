function dat  =  testing(algo,dat)
%dat =  testing(algo,dat)
% Preprocess categorical variables values.
% Inputs:
% algo -- A "code_categorical" object.
% dat -- A test data object.
% Returns:
% dat -- Preprocessed datalgo.

% Isabelle Guyon -- February 2009 -- isabelle@clopinet.com

if algo.algorithm.verbosity>0
    disp(['testing ' get_name(algo) '... '])
end

X=get_x(dat); 
[p, n]=size(X);
non_cate=setdiff(1:n, algo.cate_idx);
X=X(:, non_cate);
dat=set_x(dat, X);

dat=set_name(dat,[get_name(dat) ' -> ' get_name(algo)]); 
  

 