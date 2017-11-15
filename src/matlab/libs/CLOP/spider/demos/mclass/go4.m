disp(['This demo compares kde, one_vs_rest and 1-nn on the Brown Yeast dataset (5 classes) with 10-fold CV']);
disp(' ');

clear classes;  s=spider_path; 
load([s 'demos/data/yeastXYmc5norm']); 

[r,a]=train(cv({kde('ridge=0.0001') one_vs_rest knn}),data(X,Y));
get_mean(r,'class_loss')

