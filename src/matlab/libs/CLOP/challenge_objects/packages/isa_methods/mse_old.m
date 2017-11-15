function [W,b] = mse(X,Y)
%[W,b] = mse(X,Y)
% MSE mean squared error via pseudo-inverse

% Isabelle Guyon -- March 2000 -- isabelle@clopinet.com

[p,n]=size(X);
% Compute the weights
xi = [X, ones(p,1)]; % Add 1 for the bias
xixiTI=pinv(xi*xi');
xiI=xi'*xixiTI;
Wb=Y'*xiI';
W=Wb(1:n);
b=Wb(n+1);
