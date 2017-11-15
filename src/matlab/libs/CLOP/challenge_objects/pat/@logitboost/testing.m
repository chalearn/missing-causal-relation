function dat  =  testing(algo,dat)
%dat =  testing(algo,dat)
% Test a Logitboost classifier.
% Inputs:
% algo -- A lb classifier object.
% dat -- A test data object.
% Returns:
% dat -- The same data structure, but X is replaced by the class label
% predictions on test data.

% Isabelle Guyon -- September 2006 -- isabelle@clopinet.com

X_te=full(get_x(dat)); % Sparse matrices not supported?

% Note: after training, the number of units can be changed, if desired
algo.units=min(algo.units, algo.nboost);
preds=fevalR('LBtest', 'lb', algo.lb, 'xtest', X_te, ...
    'nunits', algo.units, 'graphic', algo.graphic);

% Convert back in the 01 range
if algo.input_type==0
    preds.resu=(preds.resu+1)/2;
end

if algo.algorithm.use_signed_output
    dat=set_x(dat, sign(preds.resu));
else
    dat=set_x(dat,preds.resu); 
end
 
dat=set_name(dat,[get_name(dat) ' -> ' get_name(algo)]); 
  

 