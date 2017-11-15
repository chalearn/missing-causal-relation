disp(['This demo compares svm with rfe, svm with l0 and fisher on a toy problem.']);
disp('[press a key]')
pause
spider_path;
rand('seed',1);
m = 50;
d = 1000;
X = rand(m,d);
X(:,3) = X(:,2) + 0.1*(rand(m,1)-0.5);
X(:,4) = X(:,1) + 0.1*(rand(m,1)-0.5);
X(:,5:8) = X(:,1:4) + 0.1*(rand(m,4)-0.5);
Y =2*( (X(:,1) + X(:,2) < 1) - 0.5);
d = data('toy pb',X,Y);
a1=param(l0(svm,'output_rank=0'),'feat',[2 5 10]);
a2=param(rfe(svm,'output_rank=0'),'feat',[2 5 10]);
a3=param(fisher,'feat',[2 5 10]);
a=cv({a1 a2 a3},'folds=2');
[r a]=train(a,d);
get_mean(r)