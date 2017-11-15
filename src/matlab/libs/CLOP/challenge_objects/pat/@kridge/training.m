function [retDat,algo] =  training(algo,retDat)
%[retDat,algo] =  training(algo,retDat)
% Train a ridge regression kernel classifier.
% Only 3 kernels are supported for the challenge:
%    linear                             k(x,y)=x.y
%    poly                poly degree q, k(x,y)=(x.y+1)^q
%    rbf                 sigma,         k(x,y)=exp(-|x-y|^2/(2*sigma^2))
% Inputs:
% algo -- A kernel ridge regression classifier object.
% retDat -- A training data object.
% Returns:
% retDat -- The same data structure, but X is replaced by the class label
% predictions on training data.
% algo -- The trained ridge regression classifier.

% Isabelle Guyon -- September 2005 -- isabelle@clopinet.com

if algo.algorithm.verbosity>0
    disp(['training ' get_name(algo) '... '])
end

X=get_x(retDat); 
Y=get_y(retDat); 
[p,n]=size(X);

% Set the gamma in a heuristic way
% as the median of ||x-y||^2
if isempty(algo.gamma)
    [XX,Euclid2] = svc_prepare(X);
    E=Euclid2(:);
    E=E(find((abs(E)>10^-14)));
    algo.gamma=1/median(E);
    algo.child.kerparam=[algo.child.kerparam algo.gamma];
    fprintf('Chosen gamma=%g\n', algo.gamma);
end

ridge_list=algo.shrinkage;
q=algo.degree;
gamma=algo.gamma;
kernel=algo.child.ker;
coef0=algo.coef0;

% Set the targets in a "balanced way"
T=Y;
if algo.balance
    pidx=find(Y>0);
    nidx=find(Y<0);
    T(pidx)=length(nidx);  
    T(nidx)=-length(pidx); 
end
    
[U, S, V, kernel, q, gamma, ridge, mse, mse_loo, errate, err_loo] = kernel_ridge(X, T, kernel, q, gamma, ridge_list,[],[],coef0);

% Get the best ridge value
[algo.mse_loo, idxi]=min(mse_loo);
ridge=ridge_list(idxi);
algo.mse=mse(idxi);
algo.errate=errate(idxi);
algo.err_loo=err_loo(idxi);

% Compute the corresponding model parameters    
[p,n]=size(X);
D=S.^2;
DI=1./(D+ridge);
RDI=DI(:, ones(length(DI),1));
if ~isempty(strfind(kernel, 'linear')) | (~isempty(strfind(kernel, 'poly')) & q==1 & isempty(strfind(kernel, 'rbf')))
    XX=[X, coef0*ones(p,1)];
    if n+1<p,
        if algo.algorithm.verbosity>0, disp 'case A'; end
        a = (V.*RDI')*(V'*(XX'*Y));
    else
        if algo.algorithm.verbosity>0, disp 'case B'; end
        a = XX'*((U.*RDI')*(U'*Y)); 
    end
    algo.W=a(1:n)';
    algo.b0=a(n+1)*coef0;
    algo.Xsv=[]; % save memory
    algo.alpha=[]; % save time
else
    if strcmp(algo.child.ker, 'linear')& strcmp(kernel, 'poly')
        algo.child.ker='poly';
    end        
    KI = U*(RDI.*U'); 
    algo.alpha= real(KI*Y);
    algo.Xsv=retDat;                

    %% code to find which alphas were actually used
    fin = find( abs( algo.alpha)>algo.alpha_cutoff);
    algo.alpha = algo.alpha(fin);
    algo.Xsv = get( algo.Xsv, fin);
end

% Change the ridge to its "trained" value
algo.shrinkage=ridge;
fprintf('Chosen ridge=%g\n', ridge);

if algo.algorithm.do_not_evaluate_training_error
    retDat=set_x(retDat,get_y(retDat)); 
else
    retDat=test(algo,retDat);
end
        








