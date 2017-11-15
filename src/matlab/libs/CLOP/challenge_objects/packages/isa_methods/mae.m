function [s, ns] = mae(X,Y)
%[s, ns] = mae(X,Y)
% MAE mean absolute error 
% s = the mean absolute error
% ns = normalize mean absolute error

% Isabelle Guyon -- March 2013 -- isabelle@clopinet.com

s=mean(abs(X-Y));

if nargout>1
    mu=mean(Y);
    n=mean(abs(Y-mu));

    ns=s/n;
end