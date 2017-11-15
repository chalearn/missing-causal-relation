function [W, b, mse, mse_loo, errate, err_loo] = kernel_least_square(X, Y, ridge)
%[W, b, mse, mse_loo, errate, err_loo] = kernel_least_square(X, Y, ridge)
% Do a least square regression by the pseudo-inverse method.
% Add a ridge if provided.
% Can be used for classification if the Y values are +-1.
% Inputs:
% X     --      Data matrix, (p, n), p patterns, n features.
% Y     --      Target vector, dim (p, 1)
% ridge --      Scalar to be added to the diagonal of the Gram matrix
% Returns:
% W     --      Weight vector, dim (p, 1)
% b     --      Bias value
% mse   --      Mean square error
% mse_loo --    Leave one out mean square error
% errate  --    Error rate (classification case only)
% err_loo --    Bound on the leave one out error rate (classification only)

% Isabelle Guyon -- April 2003 -- isabelle@clopinet.com

if nargin<3, ridge=1e-10; end
[p,n]=size(X);

XX=[X, ones(p,1)];  % Add one for the bias
if(n<p)
    gram=XX'*XX+ridge*eye(n+1); % Gram is a (n,n) matrix
    igram=pinv(gram);
    iXX=igram*XX';
else
    gram=XX*XX'+ridge*eye(p); % Gram is a (p,p) matrix
    igram=pinv(gram);
    iXX=XX'*igram;
end

a=Y'*iXX';
W=a(1:n);
b=a(n+1);

% MSE calculation
if nargout>2
    Yhat=XX*a';
    R=(Y-Yhat); % Residual vector
    mse=mean(R.^2);
end

% MSE LOO
if nargout>3
    diagP=diag(XX*iXX);
    R_loo=R./(1-diagP); % Residual for the loo
    mse_loo=mean(R_loo.^2);
end
% Note: the R squared statistic is easily obtained as: R2=1-mse/var(Y)

% Error rate calculation
if nargout>4
    if all(Y.^2==1) 
        errate = mean(Y.*Yhat<0);
    else
        errate = NaN; % cannot compute an error rate if not a classification case
    end
end

% Bound on the loo errate
if nargout>5
    if all(Y.^2==1) 
        if n<p % We need to invert another matrix, may be slowwwww
            gram=XX*XX'+ridge*eye(p); % Gram is a (p,p) matrix
            igram=pinv(gram);
        end % else (p<=n), the good case, igramis already calculated
        beta = Y'*igram'; % vector of y_i alpha_i, a=beta*XX; 
        Yhat_loo = Yhat - beta'.*(1./diag(igram)-ridge);
        err_loo = mean(Y.*Yhat_loo<0);
    else
        err_loo = NaN; % cannot compute an error rate if not a classification case
    end
end
    