disp(['This demo compares non-linear svm with and without rfe on a non-linear toy problem.']);
disp('[press a key]')
pause
spider_path; 
m = 100;
d = 50;
X = rand(m,d);
Y = 2*xor(max(0,sign(X(:,1)-0.5)),max(0,sign(X(:,2)-0.5)))-1;
d = data('nonlin toy pb',X,Y);
k = kernel('poly',2);
s=svm(k);
a1=param(rfe(s,'output_rank=0'),'feat',[2 5 10]);
a=cv({a1 s});
[r a]=train(a,d);
get_mean(r)
