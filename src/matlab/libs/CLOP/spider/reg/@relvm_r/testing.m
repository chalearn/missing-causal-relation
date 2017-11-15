function dat  =  testing(algo,dat)



%  if isempty(algo.child.dat) % maybe used a custom ker to train and then changed!
%    kerMaTemp=get_kernel(algo.child,dat,algo.xSV);
%  else
%    kerMaTemp=test(algo.child,dat);  
%    kerMaTemp=kerMaTemp.X;
%  end

  %% <<---To avoid large kernel matrices, we test in batches---> 
  
  PHI = calc(algo.child,algo.Xsv,dat);

 
  yEst	= PHI* algo.alpha;
  
  

  if algo.algorithm.use_signed_output==1
    yEst=sign(yEst);
  end

  dat=set_x(dat,yEst); 
  dat=set_name(dat,[get_name(dat) ' -> ' get_name(algo)]); 
 