function dat  =  testing(algo,dat)
%dat =  testing(algo,dat)
% Test a support vector classifier.
% Only 3 kernels are supported for the challenge:
%    linear                             k(x,y)=x.y
%    poly                poly degree d, k(x,y)=(x.y+1)^d
%    rbf                 sigma,         k(x,y)=exp(-|x-y|^2/(2*sigma^2))
% Inputs:
% algo -- A svc classifier object.
% dat -- A test data object.
% Returns:
% dat -- The same data structure, but X is replaced by the class label
% predictions on test data.

% Isabelle Guyon -- September 2005 -- isabelle@clopinet.com

n=get_name(algo);
if ~isempty(strfind(n, 'kernel linear'))
    dat=ld_test(algo, dat);
else
    dat=ker_test(algo, dat);
end

if algo.algorithm.use_signed_output
    dat=set_x(dat, sign(get_x(dat)));
end
 
dat=set_name(dat,[get_name(dat) ' -> ' get_name(algo)]); 
  

 