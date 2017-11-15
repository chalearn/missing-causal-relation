function [param, idx_out]=KNN_train2(X_train, Y_train, idx_in, flog)
%[param, idx_out]=KNN_train2(X_train, Y_train, idx_in, flog)
% There is no training for the nearest neighbor classifier, except a bias
% adjustment.
% Inputs:
% X_train -- Training data matrix of dim (num examples, num features).
% Y_train -- Training output matrix of dim (num examples, 1).
% idx_in -- Indices of the subset of features selected by preprocessing.
% flog   -- Log file descriptor.
% Returns:
% param -- a structure vector with two elements for each value of K:
% param(i).K -- Number of neighbors.
% param(i).b -- Bias value.
% idx_out -- Indices of the subset of features effectively 
%            used/selected by training.

% Isabelle Guyon -- October 2003 -- isabelle@clopinet.com

if nargin<3 |isempty(idx_in), idx_in=1:size(X_train,2); end
if nargin<4, flog=2; end

opt_K=1;
% Run the KNN classifier an get the leave-one-out predictions:
[Y_score,K]=knnclass2(X_train, Y_train,[],[],[],[],[],idx_in);
% Optimize the bias:
b=zeros(1,length(K));
for i=1:length(K)
   b(i)=bias_optimize(Y_score(:,i), Y_train);
end
% Optimize K
B=repmat(b,size(X_train,1),1);
Y_score=Y_score+B;
errate=balanced_errate(Y_score, Y_train);
[ee,ii]=min(errate);
fprintf(flog, 'K loo: %d\n', K(ii));
fprintf(flog, 'Bias loo: %g\n', b(ii));
fprintf(flog, 'Loo errate: %g\n', ee);
if opt_K
    param.K=K(ii);
    param.b=b(ii);
else
    for i=1:length(K)
        param(i).K=K(i);
        param(i).b=b(i);
    end
end

idx_out=idx_in;