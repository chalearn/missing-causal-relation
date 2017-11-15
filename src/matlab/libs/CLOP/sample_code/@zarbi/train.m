function [data, model]=train(model, data)
%[data, model]=train(model, data)
% Simple linear classifier following Golub's method.
% Inputs:
% model     -- A zarbi learning object.
% data      -- A data object.
% Returns:
% model     -- The trained model.
% data      -- A new data structure containing the results.

% Isabelle Guyon -- isabelle@clopinet.com -- May 2005

fprintf('Training zarbi ... ');
X=data.X;
Y=data.Y;
Posidx=find(Y>0);
Negidx=find(Y<0);
Mu1=mean(X(Posidx,:));
Mu2=mean(X(Negidx,:));
Var1=runvar(X(Posidx,:));
Var2=runvar(X(Negidx,:));
Sigma1=sqrt(Var1);
Sigma2=sqrt(Var2);
fudge=median(Sigma1+Sigma2);
model.W=(Mu1-Mu2)./(fudge+(Sigma1+Sigma2)+eps);
B=(Mu1+Mu2)/2;
model.b0=-model.W*B';
% Test the model
data=test(model, data);
