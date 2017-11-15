function [s, r2] = mse(X,Y)
%[s, r2] = mse(X,Y)
% s-- the mse
% r2-- the r quared statistic i.e. mse normalized by variance
% MSE mean squared error 

% Isabelle Guyon -- March 2013 -- isabelle@clopinet.com

s=mean((X-Y).^2);

if nargout>1
    n=var(Y,1);
    r2=s/n;
end