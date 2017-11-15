function dat  =  testing(algo,dat)
%dat =  testing(algo,dat)
% Test by using the new bias.
% Inputs:
% algo -- A Bias object.
% dat -- A test data object.
% Returns:
% dat -- The same data structure, but X is replaced by the class label
% predictions on test data.

% Isabelle Guyon -- February 2006 -- isabelle@clopinet.com

n=get_name(algo);
X=get_x(dat);

if algo.option==4
    % Transductive method
    p=length(X);
    ppos=p*algo.fpos;
    fp=floor(ppos);
    [sx, ix]=sort(-X);
    algo.b0=0.5*(sx(fp)+sx(fp+1));
end

X=X+algo.b0;
dat=set_x(dat,X);

if algo.algorithm.use_signed_output
    dat=set_x(dat, sign(get_x(dat)));
end
 
dat=set_name(dat,[get_name(dat) ' -> ' get_name(algo)]); 
  

 