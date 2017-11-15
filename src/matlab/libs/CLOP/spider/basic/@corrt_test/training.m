
function [d,a] = training(a,d)
  

  if isa(a.child,'algorithm')
    [d a.child]=train(a.child,d);
  end
  
  if isa(d,'data') r=d; return; end;
  d.group='separate'; %% temporarily deal with each item separately
  
  if isempty(a.loss_type)
    d=calc_corrt_test(d,a.ntrain,a.ntest,a.alpha);
  else
    d=calc_corrt_test(d,a.ntrain,a.ntest,a.alpha,a.loss_type);
  end


 
  
    

