function dat  =  testing(algo,dat)
%dat =  testing(algo,dat)
% Test a least square support vector classifier.
% Inputs:
% algo -- A lssvm classifier object.
% dat -- A test data object.
% Returns:
% dat -- The same data structure, but X is replaced by the class label
% predictions on test data.

% Isabelle Guyon -- September 2006 -- isabelle@clopinet.com

n=get_name(algo);

%if 1==2
    if ~isempty(strfind(n, 'kernel linear'))
        dat=ld_test(algo, dat);
    else
        dat=ker_test(algo, dat);
    end

    if algo.algorithm.use_signed_output
        dat=set_x(dat, sign(get_x(dat)));
    end
%end

%model=algo;
%model.Xsv=model.Xsv.X;
%[dat, model]=lssvm_demo(model, dat);

dat=set_name(dat,[get_name(dat) ' -> ' get_name(algo)]); 
  

 