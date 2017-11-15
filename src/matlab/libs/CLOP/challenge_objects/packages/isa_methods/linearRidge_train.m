function [param, idx_out]=linearRidge_train(X_train, Y_train, idx_in, flog, ridge)
%[param, idx_out]=linearRidge_train(X_train, Y_train, idx_in, flog, ridge)
% This simple but efficient two-class non-linear classifier 
% of the type Y_hat = W X + b 
% is an linear ridge regression classifier.
% Inputs:
% X_train   -- Training data matrix of dim (num examples, num features).
% Y_train   -- Training output matrix of dim (num examples, 1).
% idx_in    -- Indices of the subset of features selected by preprocessing.
% flog      -- Log file descriptor.
% ridge     -- Regularization of kernel matrix parameter.
% Returns:
% param     -- a structure with two elements
% param.Alpha -- Weights of the patterns of dim (num_patt,1)
% param.b   -- Bias value.
% idx_out   -- Indices of the subset of features effectively 
%               used/selected by training.

% Isabelle Guyon -- October 2003 -- isabelle@clopinet.com

if nargin<3 | isempty(idx_in), idx_in=1:size(X_train,2); end
if nargin<4 | isempty(flog), flog=1; end
if nargin<5 | isempty(ridge), ridge = 10.^-[0:14]; end    % Regularization of kernel matrix
debug=0;

kernel='linear'; 
q=1; 
gamma=0;

X=X_train(:,idx_in);
Y=Y_train;
[U, S, V, kernel, q, gamma, ridge, mse, mse_loo, errate, err_loo] = kernel_ridge(X, Y, kernel, q, gamma, ridge);
%[U, S, V, kernel, q, gamma, ridge, mse, mse_loo, errate] = kernel_ridge(X, Y, kernel, q, gamma, ridge);
[mini, idxi]=min(mse_loo);
xi=ridge(idxi);
if debug, 
    mse, mse_loo, errate, err_loo,
    fprintf('ridge chosen %g\n', xi);
end
fprintf(flog, 'ridge selected %g (%dth/%d)\n', xi, idxi, length(ridge));
%fprintf('%5.3f ', err_loo);

[p,n]=size(X);
D=S.^2;
DI=1./(D+xi);
if n+1<p,
    if debug, disp 'case A'; end
    a = (V.*repmat(DI',length(DI),1))*(V'*([X, ones(p,1)]'*Y));
else
    if debug, disp 'case B'; end
    a = [X, ones(p,1)]'*((U.*repmat(DI',length(DI),1))*(U'*Y));
end

param.kernel = kernel; 
param.q=q;
param.gamma=gamma;
param.W=a(1:n)';
param.b=a(n+1);
param.xi=xi;
param.mse=mse(idxi);
param.mse_loo=mse_loo(idxi);
param.errate=errate(idxi);
param.err_loo=err_loo(idxi);

% Re-optimize the bias (if binary targets)
if length(unique(Y))==2 
    [Yresu,Yconf]=ld_predict(X, param, (1:size(X,2)), X, Y);
    Output=Yresu.*Yconf;
    param.b=param.b+bias_optimize(Output,Y);
end

idx_out=idx_in;

return