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
x=get_x(dat);

y=algo.s * tanh(algo.W*x+algo.b0) + algo.y0;
dat.X=y;
 
dat=set_name(dat,[get_name(dat) ' -> ' get_name(algo)]); 
  

 