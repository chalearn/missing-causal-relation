function [param, idx_out]=naivebayes(X_train, Y_train, idx_in)
%[param, idx_out]=naivebayes(X_train, Y_train, idx_in)
% This binary 0/1 inputs value naive Bayes algorithm, leading
% to a linear classifier.
% The Naive Bayes classifier is based on the symplifying assumption that
% the attribute values are conditionally independent given the target
% value. If this hypothesis is satisfied, the naive Bayes classification is
% equivalent to the MAP classification.
% Inputs:
% X_train -- Training data matrix of dim (num examples, num features) of binary 0/1 features.
% Y_train -- Training output matrix of dim (num examples, 1) of binary values.
% idx_in -- Indices of the subset of features selected by preprocessing.
% Returns:
% param -- a structure with two elements
% param.W -- Weight vector of dim (1, num features)
% param.b -- Bias value.
% idx_out -- Indices of the subset of features effectively 
%            used/selected by training.

% Isabelle Guyon -- September 2003 -- isabelle@clopinet.com

if nargin<3, idx_in=1:size(X_train,2); end

% Reduce the data set to the features effectively used
X=X_train(:,idx_in);

% Compute the frequencies
Posidx=find(Y_train>0);
Negidx=find(Y_train<=0);
Np=length(Posidx);
Nn=length(Negidx);
XP=X(Posidx,:);
XN=X(Negidx,:);
if size(XP,1)>1, Npp=sum(XP); else Npp=XP; end
if size(XN,1)>1, Npn=sum(XN); else Npn=XN; end
% Priors to regularize
ppp=mean(Npp/Np);
ppn=mean(Npn/Nn);
% Corrected frequencies
fpp=(Npp+ppp)/(Np+1);
fnp=1-fpp;
fpn=(Npn+ppn)/(Nn+1);
fnn=1-fpn;

% Log likelihood ratio
lp=log(fpp./fpn);
ln=log(fnp./fnn);

% Class priors
fp=(Np+1)/(Np+Nn+1);
fn=(Nn+1)/(Np+Nn+1);

% Compute weigths (0/1 features)
param.W=(lp-ln);
param.b=sum(ln)+log(fp)-log(fn);

% No change in features
idx_out=idx_in;
