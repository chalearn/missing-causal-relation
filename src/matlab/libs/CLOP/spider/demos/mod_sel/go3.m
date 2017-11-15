clear classes; s=spider_path;
disp(['This demo shows simple model selection selecting the value of k of k-nn.']); 
disp('[press a key]') 
pause 

rand('seed',1);

a1=param(knn,'k',[1:2:15]);
%a1=param(svm(kernel('rbf')),'rbf',2.^[-10:3:10]);
a2=gridsel(a1); a2.score=cv(svm,'folds=6');

d=gen(toy); 
global X; global Y; 
X=d.X; Y=d.Y;
d=data_global;

[r,a]=train( cv({a1 a2},'folds=8') ,d  );

%[r,a]=train( cv(svm,'folds=3') ,d  );

get_mean(r)


