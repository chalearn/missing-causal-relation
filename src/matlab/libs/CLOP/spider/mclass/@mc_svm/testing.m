function dat =  testing(a,dat)
   
 kTemp=get_kernel(a.child,dat,a.Xsv);
% yTmp=get_y(dat);
 [r,yTemp]=max(((a.alpha'* kTemp)+a.b0*ones(1,size(kTemp,2))),[],1);
 
 yEst = -ones(get_dim(dat),size(a.alpha,2));
 
 for i=1:length(yTemp),
    yEst(i,yTemp(i))=1;
 end;
 
 dat=set_x(dat,yEst); 
 dat=set_name(dat,[get_name(dat) ' -> ' get_name(a)]); 
  
 







