function [d,a] =  training(a,d)
  
if a.algorithm.verbosity>0
   disp(['training ' get_name(a) '.... '])
end
  
x     = get_x(d);
y     = get_y(d);
a.gkm = select(a.selector, a.gkm, x, y);

if ~a.algorithm.do_not_evaluate_training_error
   d=test(a,d);
end
  
