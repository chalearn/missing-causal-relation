disp(['This demo compares multi-class svm, multi-class fisher,']) ;
disp(['one against the rest and one against one on the Brown Yeast dataset.']);
disp('[press a key]')
pause
clear classes 
global X Y;
s=spider_path;
load([s 'demos/data/yeastXYmc5norm']);
d=data_global('Multi-class Yeast 5',[],[]);
a=cv({mc_svm fisher one_vs_rest(svm) one_vs_one(svm)},'folds=2');
[r a]=train(a,d);
get_mean(r)
