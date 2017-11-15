function dat  =  testing(algo,dat)
%dat =  testing(algo,dat)
% Test a linear classifier.
% Inputs:
% algo -- A naive classifier object.
% dat -- A test data object.
% Returns:
% dat -- The same data structure, but X is replaced by the class label
% predictions on test data.

% Isabelle Guyon -- September 2005 -- isabelle@clopinet.com
% October 2015: add multiclass

n=get_name(algo);
if algo.binary < 0 % Multiclass case
    dat.X = centroid_predict(dat.X, algo.W);
else
    dat=ld_test(algo, dat);
end

if algo.algorithm.use_signed_output
    dat=set_x(dat, sign(get_x(dat)));
end
 
dat=set_name(dat,[get_name(dat) ' -> ' get_name(algo)]); 
  

 