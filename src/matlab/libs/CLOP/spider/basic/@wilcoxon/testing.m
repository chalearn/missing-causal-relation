
function dat = testing(a,dat)
   
  if isa(a.child,'algorithm')
    dat=test(a.child,dat);
  end

  if isa(dat,'data') 
        return; 
  end;
  dat.group='separate'; %% temporarily deal with each item separately
  
  if isempty(a.loss_type)
    dat=calc_wilcoxon(dat);
  else
    dat=calc_wilcoxon(dat,a.loss_type);
  end

   
  
    