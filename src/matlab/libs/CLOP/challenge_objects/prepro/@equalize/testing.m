function dat  =  testing(algo,dat)
%dat =  testing(algo,dat)
% Preprocess with equalize.
% Inputs:
% algo -- A "equalize" object.
% dat -- A test data object.
% Returns:
% dat -- Preprocessed data.

% Isabelle Guyon -- Oct 2012 -- isabelle@clopinet.com

if isempty(algo.knots) return; end

X=get_x(dat); 

XX = interpol(X, algo.xsamp, algo.ysamp);

dat=set_x(dat, XX);

dat=set_name(dat,[get_name(dat) ' -> ' get_name(algo)]); 
  

 