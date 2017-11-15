function v=runvar(X)
%v=runvar(X)
% Running average variance.
% Suitable for matrices X with large numbers of lines or columns.
% Returns the variance of the columns. Normalizes by n.

% Isabelle Guyon -- isabelle@clopinet.com -- October 2003

[p,n]=size(X);
mu=mean(X);
v=zeros(1,n);
v=(X(1,:)-mu).^2;
for i=2:p
    x2=(X(i,:)-mu).^2;
    v=((i-1)/i)*v+(1/i)*x2;
end

