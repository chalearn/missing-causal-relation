clear all;
N=100;

X1=randn(N,2);
Z=X1;
clf;

% subplot(211);
title('Kernel Vector Quantization Demo')
hold on;
plot(Z(:,1),Z(:,2),'g.');


kk=kvq;
kk.child=distance;
kk.dist=.9;

[r,a]=train(kk,data(Z));
d=data(Z);
plot(a,d)
