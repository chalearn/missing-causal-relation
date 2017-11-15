
function d = testing(a,d)
   
  if isa(a.child,'algorithm')
    d=test(a.child,d);
  end

  if isa(d,'data') r=d; return; end;
  d.group='separate'; %% temporarily deal with each item separately
  
  if isempty(a.loss_type)
    d=calc_corrt_test(d,a.ntrain,a.ntest,a.ntrials,a.alpha);
  else
    d=calc_corrt_test(d,a.ntrain,a.ntest,a.ntrials,a.alpha,a.loss_type);
  end

   
  
    