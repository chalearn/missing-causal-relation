clear classes; s=spider_path;
disp(['This demo shows simple model selection selecting the value of sigma of an RBF kernel.']); 
disp('[press a key]') 
pause 

rand('seed',1);

a1=param(svm(kernel('rbf')),'rbf',2.^[-10:3:10]);
a2=gridsel(a1); 

d=gen(toy);

[r,a]=train( cv({a1 a2},'folds=5;store_all=1') ,d  );

get_mean(r) 



