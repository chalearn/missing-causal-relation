function [param, idx_out]=kernelRidge_train(X_train, Y_train, idx_in, kernel, q, gamma, ridge0)
%[param, idx_out]=kernelRidge_train(X_train, Y_train, idx_in, kernel, q, gamma, ridge0)
% This simple but efficient two-class non-linear classifier 
% of the type Y_hat=sum_k alpha_k k(x,x_k)+b 
% is an RBF ridge regression classifier.
% Inputs:
% X_train   -- Training data matrix of dim (num examples, num features).
% Y_train   -- Training output matrix of dim (num examples, 1).
% idx_in    -- Indices of the subset of features selected by preprocessing.
% gamma     -- Radial kernel parameter.
% ridge0     -- Regularization of kernel matrix parameter.
% Returns:
% param     -- a structure with two elements
% param.Alpha -- Weights of the patterns of dim (num_patt,1)
% param.b   -- Bias value.
% idx_out   -- Indices of the subset of features effectively 
%               used/selected by training.

% Isabelle Guyon -- October 2003 -- isabelle@clopinet.com

if nargin<3 |isempty(idx_in), idx_in=1:size(X_train,2); end
X=X_train(:,idx_in);
Y=Y_train;

if nargin<4, kernel='radial2'; end % general2
if nargin<5, q=1; end

[r, g, uv, D2]=radius_grain(X);
if nargin<6, 
    % Set the gamma 
    %s=r/g;
    %gamma=[g/s^3, g/s^2, g/s, g, r, r*s, r*s^2, Inf].^-2; 
    %gamma=[g/s^3, g/s^2, g/s, g].^-2;
    %gamma=[0.125 0.25 0.5 1 2 4 8 16 32 64 128 256] ;
    %gamma=[3 4 5 6 7] ;
    %s=sqrt(r/g);
    %d=g*s.^[-1:3];
    %gamma=d.^-2;
    %lambda=2.^[-8:8];
    %gamma=g^-2.*lambda;
    %lambda=2.^[-35:-20]; %[0:8]
    %gamma=g^-2.*lambda;
    %gamma=[10^-16, 5*10^-16, 10^-15, 5*10^-15, 10^-14, 5*10^-14, 10^-13, 5*10^-13, 10^-12, 5*10^-12, 10^-11, 5*10^-11, 10^-10, 5*10^-10, 10^-9, 5*10^-9, 10^-8, 5*10^-8, 10^-7, 5*10^-7, 10^-6, 5*10^-6, 10^-5, 5*10^-5, 10^-4, 5*10^-4];
    gamma=10.^-[16:-1:0];
end
if nargin<7, ridge0 = 10.^-[0:16]; end    % Set the regularization of kernel matrix

Alpha=zeros(length(Y_train), length(gamma));
opt_ridge=zeros(1,length(gamma));
opt_errate=zeros(1,length(gamma));
opt_err_loo=zeros(1,length(gamma));
opt_mse=zeros(1,length(gamma));
opt_mse_loo=zeros(1,length(gamma));
idxi=zeros(1,length(gamma));
% In the loop, the ridge is optimized
for i=1:length(gamma)
    %fprintf('\ngamma=%g\n', gamma(i));
    [U, S, V, kernel, q, gg, ridge, mse, mse_loo, errate, err_loo] = kernel_ridge(X, Y, kernel, q, gamma(i), ridge0, uv, D2);
    mse_loo=mse_loo+1e-14*[1:length(mse_loo)]; % break ties, favor larger ridges.
    %fprintf('%5.3f ', err_loo);
    %fprintf('\n');
    %fprintf('%5.3f ', mse_loo);
    [opt_mse_loo(i), idxi(i)]=min(mse_loo);
    opt_ridge(i)=ridge(idxi(i));
    D=S.^2;
    DI=1./(D+opt_ridge(i));
    KI = U*(repmat(DI,1,length(DI)).*U'); 
    Alpha(:,i)= KI*Y;
    opt_mse(i)=mse(idxi(i));
    opt_errate(i)=errate(idxi(i));
    opt_err_loo(i)=err_loo(idxi(i));
end
% Now we get the best gamma and the corresponding best ridge (doubly optimized)
nl=length(opt_mse_loo);
% Compute the Q2:
den=var(Y_train,1);
den(den==0)=eps;
Q2=1-opt_mse_loo/den;
% Round the Q2 to 2 significative digits
Q2=round(Q2*100)/100;
% Break ties, favor smaller gammas
Q2=Q2-1e-14*[1:length(Q2)];
%fprintf('\n\n==> Optimizing gamma, show Q2 and mse_loo\n');
%fprintf('%5.3f ', Q2);
%fprintf('\n');
%fprintf('%5.3f ', opt_mse_loo);
%fprintf('\n');
[maxj, idxj]=max(Q2);
opt_gamma=gamma(idxj);
opt_opt_ridge=opt_ridge(idxj);
alpha=Alpha(:,idxj);
id=idxi(idxj);
opt_opt_mse=opt_mse(idxj);
opt_opt_mse_loo=opt_mse_loo(idxj);
opt_opt_errate=opt_errate(idxj);
opt_opt_err_loo=opt_err_loo(idxj);

%fprintf('kernel %s\n', kernel);
%fprintf('q %g\n', q);
fprintf('gamma computed %g (%dth/%d)\n', opt_gamma, idxj, length(gamma));
fprintf('ridge selected %g (%dth/%d)\n', opt_opt_ridge, id, length(ridge));
%fprintf('%5.3f ', err_loo);

param.kernel = kernel; 
param.q=q;
param.gamma=opt_gamma;
param.Alpha=real(alpha);
param.b=0;
param.ridge=opt_opt_ridge;
param.mse=real(opt_opt_mse);
param.mse_loo=real(opt_opt_mse_loo);
param.errate=opt_opt_errate;
param.err_loo=opt_opt_err_loo;

% Re-optimize the bias (if binary targets)
if length(unique(Y))==2 
    [Yresu,Yconf]=kernel_predict(X, param, (1:size(X,2)), X, Y);
    Output=Yresu.*Yconf;
    param.b=param.b+bias_optimize(Output,Y);
end

idx_out=idx_in;

return