function [U, S, V, kernel, q, gamma, ridge, mse, mse_loo, errate, err_loo] = kernel_ridge(X, Y, kernel, q, gamma, ridge, uv, D2, coef0)
%[U, S, V, kernel, q, gamma, ridge, mse, mse_loo, errate, err_loo] = kernel_ridge(X, Y, kernel, q, gamma, ridge, uv, D2, coef0)
% Do a kernel least square regression with varying ridge values by
% diagonalization.
% Can be used for classification if the Y values are +-1.
% Inputs:
% X         --      Data matrix, (p, n), p patterns, n features.
% Y         --      Target vector, dim (p, 1)
% kernel    -- Name of the dot product kernel function 'inputlinear' to force wx+b or  
%                    'linear', 'polynomial', 'radial', etc. For a list type help svc_dp.
% q         -- Degree of polynomial in kernel function.
% gamma     -- Locality parameter in kernel function.
% ridge     -- A list of values to be added to the diagonal of the Gram/Kernel matrix
% uv        -- Outer product of the X matrix: X*X'
% D2        -- Matrix of squared Euclidean distances between patterns.
% coef0     -- Kernel bias value for libsvm compatibility.
% Returns:
% U S V     --      Result of the singular decomposition of X (linear case) or U eigen vectors of
%                   K (kernel case) and S square root of eigen values. Last case: V is empty.
%                   First case, U is empty if not needed.
%                   We provide only the diagonal elements od S, use diag to
%                   reconstitute the matrix.
% mse   --      Mean square error
% mse_loo --    Leave one out mean square error
% errate  --    Error rate (classification case only)
% err_loo --    Bound on the leave one out error rate (classification only)

% Isabelle Guyon -- October 2003 -- isabelle@clopinet.com

if nargin<3, kernel='linear'; end
if nargin<4, q=1; end
if nargin<5, gamma=1; end
if nargin<6, ridge=1e-10; end
if nargin<7, uv=[]; end
if nargin<8, D2=[]; end
if nargin<9, coef0=1; end

debug=1;

% Compute the eigenvectors and eigenvalues
[p,n]=size(X);
K=[];
U=[];
V=[];
if(~isempty(strfind(kernel, 'linear')) & (n+1)<p ) 
    X_train=[X, coef0*ones(p,1)];  % Add one for the bias
    if nargout<10,
        [V,D] = eig(X_train'*X_train); % Matrix (n+1,n+1)
        D=diag(D);
        D(D<0)=0;
        S=sqrt(D);
        if debug, disp 'case1'; end
        % Here we are cheap, we do not compute U, which can be computationally expensive
    else
        if debug, disp 'case2'; end
        [U,S,V] = svd(full(X_train),0);
        S=diag(S);
        S(S<0)=0;
        D=S.^2; 
    end 
    % The discriminant function can be computed as:
    % X_test*V*(D+ridge*I)^-1*V'*X_train'*Y
    % or
    % X_test*X_train'*U*S^-1*(D+ridge*I)^-1*S*U'*Y
    % or else the weight vector:
    % a = V*(D+ridge*I)^-1*V'*X_train'*Y;
    % or
    % a = X_train'*U*(D+ridge*I)^-1*U'*Y;
    % W=a(1:n);
    % b=a(n+1);  
else
    if debug, disp 'case3'; end
    if strcmp(kernel, 'linear'), 
        kernel='polynomial'; q=1; % to add a bias
    end
    K = full(svc_dp(kernel, X, X, q, gamma, uv, D2, coef0));
    [U,D] = eig(K);
    D=diag(D);
    D(D<0)=0;
    S=sqrt(D);
    % The discriminant function can be computed as:
    % K(X_test,X_train)*U*S^-1*(D+ridge*I)^-1*S*U'*Y
end
    
% Compute the performance on the training set
mse=zeros(size(ridge));
mse_loo=zeros(size(ridge));
errate=zeros(size(ridge));
err_loo=zeros(size(ridge));
MD=max(D);
ridge=ridge*MD;
for i=1:length(ridge)
    if ridge(i)==0, ridge(i)=1e-14; end
    
    % MSE calculation
	if nargout>7
        DI=1./(D+ridge(i));
        if isempty(K)
            %XI = (V*(repmat(DI,1,length(DI)).*V'))*X_train';
            XI = (V*(DI(:,ones(length(DI),1)).*V'))*X_train';
            %P =  X_train*XI; too big to compute
            Yhat=X_train*(XI*Y);
            diagP=sum(X_train.*XI',2);
        else
            %KI = U*(repmat(DI,1,length(DI)).*U'); 
            KI = U*(DI(:,ones(length(DI),1)).*U'); 
            P = K*KI;
            Yhat=P*Y;
            diagP=diag(P);
        end
        R=(Y-Yhat); % Residual vector
        mse(i)=mean(R.^2);
	end
	
	% MSE LOO
    warning off MATLAB:divideByZero
	if nargout>8
        R_loo=R./(1-diagP); % Residual for the loo
        mse_loo(i)=mean(R_loo.^2);
	end
    warning on MATLAB:divideByZero
	% Note: the R squared statistic is easily obtained as: R2=1-mse/var(Y)
	
	% Error rate calculation
	if nargout>9
        if length(unique(Y))==2
            errate(i) = mean(Y.*Yhat<0);
        else
            errate(i) = NaN; % cannot compute an error rate if not a classification case
        end
	end
	
	% Bound on the loo errate
    err_loo(i) = NaN; % default value =)
	if nargout>10 & size(U,1)<20000 %(otherwise too big)
        if length(unique(Y))==2 
            if isempty(K)
                Up=DI(:,ones(size(U,1),1)).*U';
                beta=U*(Up*Y);
                diagKI=sum(U.*Up',2);
                %KI = U*(repmat(DI,1,size(U,1)).*U'); % too big to compute
            else
                beta = KI*Y; % vector of y_i alpha_i, a=beta*XX; 
                diagKI=diag(KI);
            end
            warning off MATLAB:divideByZero
            Yhat_loo = Yhat - beta.*(1./diagKI-ridge(i));
            warning on MATLAB:divideByZero
            err_loo(i) = mean(Y.*Yhat_loo<0);
        else
            err_loo(i) = NaN; % cannot compute an error rate if not a classification case
        end
	end
end

return
        