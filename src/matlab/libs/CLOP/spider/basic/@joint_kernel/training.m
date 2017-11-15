
function [d,a] = training(a,d)

  a.dat=d;

  if ~a.algorithm.do_not_evaluate_training_error
    d = data(get_name(d),feval('calc',a,d),d.Y);
  end
