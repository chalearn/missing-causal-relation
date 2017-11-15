
function [dat,algo] = training(algo,dat)
  

  if isa(algo.child,'algorithm')
    [dat algo.child]=train(algo.child,dat);
  end
  
  if isa(dat,'data') 
       return; 
  end;
  dat.group='separate'; %% temporarily deal with each item separately
  
  if isempty(algo.loss_type)
    dat=calc_wilcoxon(dat);
  else
    dat=calc_wilcoxon(dat,algo.loss_type);
  end


 
  
    

