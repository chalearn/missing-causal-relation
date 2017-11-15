function [dat,a] =  training(a,dat)

 disp(['training ' get_name(a) '.... '])
 kern=get_kernel(a.child,dat,[]);   %% calc kernel
 y=get_y(dat);
 % Transform y
 [r,yTemp] =max(y,[],2); 
  
 [a.alpha, a.b0] = svm_multi_predK(yTemp,yTemp,a.C,kern);
 a.Xsv=dat;
 dat=test(a,dat);
