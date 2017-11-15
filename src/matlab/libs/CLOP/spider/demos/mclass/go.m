disp(['This demo compares one-against-the-rest svm and knn with different k on the Brown Yeast dataset (5 classes).']);
disp('[press a key]')
pause
clear classes 
% global X Y;
s=spider_path;
load([s 'demos/data/yeastXYmc5norm']);
global X;global Y; 
 
d=data_global('Multi-class Yeast data (5 classes)',[],[]);
  
k = kernel('rbf',5);
a1 = one_vs_rest(svm({k}));
s = group({a1 ,knn(k),knn('k=3')});
a=cv(s,'folds=10');
[r a]=train(a,d);
get_mean(r)
