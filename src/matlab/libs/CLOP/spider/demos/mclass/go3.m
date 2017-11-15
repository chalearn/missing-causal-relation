%% test on the yeast Brown 5 classes

disp(['This demo runs mc_svm with l0 feature selection on Yeast data.']);
disp(' ');

clear classes 
global X Y;
s=spider_path;

load([s 'demos/data/yeastXYmc5norm']);
d=data_global('Multi-class Yeast 5',[],[]);

s1=l0(one_vs_rest(svm('optimizer="leon"')));
s1.output_rank=0; 
s3=rfe(one_vs_rest(svm('optimizer="leon"')),{'output_rank=0','feat=10'});
s5=one_vs_rest(svm('optimizer="leon"'));
b = l0(mc_svm);
b.find_min=0;
a=feat_sel([10 20 40],b,mc_svm);
a=cv(a,'folds=8');
[r a]=train(a,d);
get_mean(r)
