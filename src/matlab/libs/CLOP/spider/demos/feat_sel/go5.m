 
disp(['This demo compares one_vs_rest svms  with and without rfe,& l0 on the Yeast (5 classes) dataset.']); 
disp('[press a key]') 
pause 
 
clear; 
clear classes; 
s=spider_path; 
 
load([s 'demos/data/yeastXYmc5norm']); 
 
global X; global Y; 
 
d=data_global('Multi-class Yeast 5',[],[]); 
 
a1=one_vs_rest(svm); 
%a1.optimizer='libsvm'; 

a2 = rfe(a1,'output_rank=0');
a2 = feat_sel([10:10:70],a2,a1);
a3 = l0(a1,'output_rank=0'); 
a3 = feat_sel([10:10:70],a3,a1);

a=cv({a1 a2 a3},'folds=2'); 


[r a]=train(a,d); 
get_mean(r)  
  
