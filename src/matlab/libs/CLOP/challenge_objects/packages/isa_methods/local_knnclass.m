function [Y_hat, K, errate, D2]=local_knnclass(X_train, Y_train, X_test, Y_test, K, D2, idxf)
%[Y_hat, K, errate, D2]=local_knnclass(X_train, Y_train, X_test, Y_test, K, D2, idxf)
% Local K nearest neighbor classifier for 2-class problems.
% This works either by providing patterns (X_train, X_test) or a distance
% matrix (D2).
% Inputs:
% X_train   --  Training data matrix, patterns in rows, dim (p_train, n_feat).
% Y_train   --  Training target values, dim p_train.
% X_test    --  Test data matrix, patterns in rows, dim (p_test, n_feat).
% Y_test    --  Test target values, dim p_test.
% K         --  Vector of num_K numbers of neighbors to be tried.
% D2        --  Matrix of distances between patterns (optional).
% Returns:  
% Y_hat     --  Prediction values, dim (p_test, num_K).
% errate    --  Resulting error rates (if Y_test is provided), dim num_K.
% D2        --  Matrix of distances between patterns.

% Isabelle Guyon -- October 2003 -- isabelle@clopinet.com

closest=1; % Index of the closest neighbor (2 if no test set for the leave-one-out).
if nargin<4, Y_test=[]; end
if nargin<3, closest=2; X_test=X_train; Y_test=Y_train; end
[pte,n]=size(X_test);
[ptr,n]=size(X_train);
pos_num=length(find(Y_train==1));
neg_num=length(find(Y_train==-1));
max_num=min(max(pos_num,neg_num),1000);
if nargin<5 | isempty(K), K=2.^[1:floor(log2(max_num))]'-1; end
KK=K+closest-1;
if nargin<6, D2=[]; end
if nargin<7, idxf=repmat(1:n,ptr,1); end

num_K=length(KK);
X_train=get_submat(X_train,idxf); % Select the right features for each pattern

Y_hat=[];
D2=zeros(ptr,pte);
for j=1:pte % loop over test examples
    for k=1:ptr % loop over training examples
        x_test=X_test(j,idxf(k,:));
        D2(k,j)=sum((X_train(k,:)-x_test).^2);
    end
end

[val,idx]=sort(D2);
YY=repmat(Y_train,1,pte);
Y_hat=zeros(pte,num_K);
for i=1:num_K
    if KK(i)==closest
        Y_hat(:,i)=YY(idx(closest,:))';
    else
        Y_hat(:,i)=mean(YY(idx(closest:KK(i),:)))';
    end
end

errate=zeros(num_K,1);
if ~isempty(Y_test)
    for i=1:num_K
        ro=Y_hat(:,i).*Y_test;
        errate(i)=mean(ro<=0);
    end
end
        
        
return