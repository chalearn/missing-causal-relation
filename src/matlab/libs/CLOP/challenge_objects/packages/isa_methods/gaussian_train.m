function [param, idx_out]=gaussian_train(X_train, Y_train, idx_in)
%[param, idx_out]=gaussian_train(X_train, Y_train, idx_in)
% This simple but efficient two-class linear classifier 
% of the type Y_hat=X*W'+b is a Gaussian bayesian classifier (Duda-Hart-73 p.26).
% Inputs:
% X_train -- Training data matrix of dim (num examples, num features).
% Y_train -- Training output matrix of dim (num examples, 1).
% idx_in -- Indices of the subset of features selected by preprocessing.
% Returns:
% param -- a structure with two elements
% param.W -- Weight vector of dim (1, num features)
% param.b -- Bias value.
% idx_out -- Indices of the subset of features effectively 
%            used/selected by training.

% Isabelle Guyon -- November 2003 -- isabelle@clopinet.com

if nargin<3 |isempty(idx_in), idx_in=1:size(X_train,2); end

X=X_train(:,idx_in);
[p, n]=size(X);
Posidx=find(Y_train>0);
Negidx=find(Y_train<=0);
p1=length(Posidx);
p2=length(Negidx);

% Compute the means
Mu1=mean(X(Posidx,:),1);
Mu2=mean(X(Negidx,:),1);

% Compute the unbiased pooled within-class variance
Var1=runvar(X(Posidx,:));
Var2=runvar(X(Negidx,:));
den=max(p-2, 1);
Var_pooled=(p1*Var1+p2*Var2)/den; % Minus 2 degrees of freedom, the 2 means.

% Add a fudge factor (prior on the variance)
%Std_pooled=sqrt(Var_pooled);
%fudge=median(Std_pooled);
%if fudge==0, fudge=mean(Std_pooled); end
%Var_pooled+fudge^2;
Var_pooled(find(Var_pooled==0))=1;

% Compute the priors
f1=p1/p;
f2=p2/p;
prior=log(f1/f2);

param.W=(Mu1-Mu2)./(2*Var_pooled);
param.b=sum((Mu2.^2-Mu1.^2)./(2*Var_pooled)) + prior;
idx_out=idx_in;

return