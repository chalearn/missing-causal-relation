clear all;
N=100;

X1=randn(N,2);
X1=X1+repmat([5,5],N,1);


Z=[X1;]

clf;

% subplot(211);
title('Kernel Vector Quantization Demo')
hold on;
plot(Z(:,1),Z(:,2),'g.');


kk=kvq;
kk.child=kernel('rbf',1);
kk.dist=0.5;

[r,a]=train(kk,data(Z));

plot(r.X(:,1),r.X(:,2),'b*');    

