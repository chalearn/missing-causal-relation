 
disp(['This demo compares multiclass svm''s with and without rfe on the Yeast (5 classes) dataset.']); 
disp('[press a key]') 
pause 
 
clear; 
clear classes; 
s=spider_path; 

global X; global Y; 

load([s 'demos/data/yeastXYmc5norm']); 
 
 
d=data_global('Multi-class Yeast 5',[],[]); 
 
k = kernel('poly',2); 
 
a1=one_vs_rest(svm(k)); 
%a1.optimizer='libsvm'; 
 
a2=mc_svm(k); 
a3 = param(rfe(a1,'output_rank=0'),'feat',[10 20]); 
a4 = param(rfe(a2,'output_rank=0'),'feat',[10 20]); 
 
a=cv({a1 a2 a3 a4},'folds=2'); 


[r a]=train(a,d); 
get_mean(r)  
  
