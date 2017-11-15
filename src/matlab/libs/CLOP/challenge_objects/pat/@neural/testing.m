function dat  =  testing(algo,dat)
%dat =  testing(algo,dat)
% Test a Neural Network classifier.
% Inputs:
% algo -- A neural network classifier object.
% dat -- A test data object.
% Returns:
% dat -- The same data structure, but X is replaced by the class label
% predictions on test data.

% Isabelle Guyon -- September 2005 -- isabelle@clopinet.com

X_te=get_x(dat); % Sparse matrices not supported
[p,n] = size(X_te);

Yhat=mlpfwd(algo.net, X_te);

% remove ties:
zero_val=find(Yhat==0);
Yhat(zero_val)=algo.algorithm.default_output*eps;

if algo.algorithm.use_signed_output
    dat=set_x(dat, sign(Yhat));
else
    dat=set_x(dat, Yhat);
end
 
dat=set_name(dat,[get_name(dat) ' -> ' get_name(algo)]); 
  

 