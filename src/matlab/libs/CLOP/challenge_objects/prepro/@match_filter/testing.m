function dat  =  testing(algo,dat)
%dat =  testing(algo,dat)
% Preprocess by matching the patterns with all the templates of a filter
% bank.
% Inputs:
% algo -- A "standard" object.
% dat -- A test data object.
% Returns:
% dat -- Preprocessed data.

% Isabelle Guyon -- November 2005 -- isabelle@clopinet.com

X=get_x(dat); 
[p,n]=size(X);

K=get_x(algo.child); % The filter bank
X=X*K';
dat=set_x(dat, X);

dat=set_name(dat,[get_name(dat) ' -> ' get_name(algo)]); 
  

 