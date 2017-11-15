


clear classes
s=spider_path;
load([s 'demos/data/colon']);

d=data(X,Y);


%% -------- learn with global custom kernel

global K;
K=X*X';

[r a]=train(svm(kernel('custom_fast')),d);


%% -------- or learn with normal custom kernel

[r a2]=train(svm(kernel('custom',X*X')),d);

[a.alpha' ; a2.alpha']




