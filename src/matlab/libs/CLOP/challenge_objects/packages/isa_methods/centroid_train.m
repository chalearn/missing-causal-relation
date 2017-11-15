function [param, idx_out]=centroid_train(X_train, Y_train, idx_in)
%[param, idx_out]=centroid_train(X_train, Y_train, idx_in)
% This simple but efficient multiclass classifier 
% classifies according to the nearest centroid.
% Inputs:
% X_train -- Training data matrix of dim (num examples, num features).
% Y_train -- Training output matrix of dim (num examples, 1).
% idx_in -- Indices of the subset of features selected by preprocessing.
% Returns:
% param -- a structure with
% param.X -- The matrix having as lines the centroid vectors
% param.sigma -- Average within class standard deviation
% idx_out -- Indices of the subset of features effectively 
%            used/selected by training.

% Isabelle Guyon -- October 2015 -- isabelle@clopinet.com

if nargin<3 || isempty(idx_in), idx_in=1:size(X_train,2); end

X=X_train(:,idx_in);
[p, n]=size(X);

% Identify the indices of the examples of each class (may overlap; support
% multilabel cases).
uval=unique(Y_train(:));
if length(uval)>2,
    cidx=cell(length(uval),1);
    if size(Y_train, 2)>1, error('Multiple multiclass targets not supported'); end
    for k=1:length(uval)
        cidx{k}=find(Y_train==uval(k));
    end
else
    pval=max(uval); % usually the positive class has label +1
    if pval~=1, warning('The positive class label is not +1, is this correct?'); end
    cidx=cell(size(Y_train, 2),1);
    for k=1:length(cidx)
        cidx{k}=find(Y_train(:,k)==pval);
    end
end

% Compute the class means
cnum=length(cidx);
param.X = zeros(cnum, n);
for k=1:cnum
    if ~isempty(cidx{k})
        param.X(k, :) = mean(X(cidx{k},:),1);
    end
end

% Compute the class variances // abandoned //
param.V=[];
if 1==2
    param.V = eps*ones(cnum, n);
    for k=1:cnum
        mu = param.X(k, :);
        c = length(cidx{k});
        if c>0
            param.V(k, :) = eps+mean((X(cidx{k},:) - mu(ones(c,1),:)).^2);
        end
    end
end

idx_out=idx_in;

return