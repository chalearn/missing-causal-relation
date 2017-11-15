function [Y_hat, K, errate, D2global, D2local]=local_knnclass2(X_train, Y_train, X_test, Y_test, K, D2global, D2local, idxf)
%[Y_hat, K, errate, D2global, D2local]=local_knnclass2(X_train, Y_train, X_test, Y_test, K, D2global, D2local, idxf)
% Local K nearest neighbor classifier for 2-class problems.
% Modified for local features and computes a ratio score.
% This works either by providing patterns (X_train, X_test) or a distance
% matrix (D2).
% Inputs:
% X_train   --  Training data matrix, patterns in rows, dim (p_train, n_feat).
% Y_train   --  Training target values, dim p_train.
% X_test    --  Test data matrix, patterns in rows, dim (p_test, n_feat).
% Y_test    --  Test target values, dim p_test.
% K         --  Vector of num_K numbers of neighbors to be tried.
% D2global  --  Matrix of distances between patterns.
% D2local   --  Matrix of distances between patterns, in idxf projection.
% Returns:  
% Y_hat     --  Prediction values, dim (p_test, num_K).
% errate    --  Resulting error rates (if Y_test is provided), dim num_K.
% D2global  --  Matrix of distances between patterns.
% D2local   --  Matrix of distances between patterns, in idxf projection.

% Isabelle Guyon -- May 2005 -- isabelle@clopinet.com

closest=1; % Index of the closest neighbor (2 if no test set for the leave-one-out).
if nargin<4, Y_test=[]; end
if nargin<3 | isempty(X_test), closest=2; X_test=X_train; Y_test=Y_train; end
[pte,n]=size(X_test);
[ptr,n]=size(X_train);
pos_num=length(find(Y_train==1));
neg_num=length(find(Y_train==-1));
max_num=min(max(pos_num,neg_num),1000);
if nargin<5 | isempty(K), K=2.^[0:floor(log2(max_num))]'; end
if nargin<6, D2global=[]; end
if nargin<7, D2local=[]; end
if nargin<8, idxf=repmat(1:n,ptr,1); end

% Similarity matrix in original space
if isempty(D2global),
    uv = X_train*X_test';
    uu = (X_train.*X_train)*(0.5*ones(size(X_train,2),1));
    uu2 = repmat(uu,1,size(X_test,1));
    vv = (X_test.*X_test)*(0.5*ones(size(X_train,2),1));
    vv2 = repmat(vv,1,size(X_train,1));
    D2global = uu2' - uv' + vv2;
end
% Take care of leave-one-out is train=test
if closest==2;
    D2global(find(D2global==0))=Inf;
end

% Look for K closest in each class
pos_idx=find(Y_train>0);
neg_idx=find(Y_train<0);
[valp,idxp]=sort(D2global(:,pos_idx),2);
idxp=pos_idx(idxp);
[valn,idxn]=sort(D2global(:,neg_idx),2);
idxn=neg_idx(idxn);

% Local discance matrix
num_K=length(K);
X_train=get_submat(X_train,idxf); % Select the right features for each pattern

if isempty(D2local)
    D2local=zeros(pte,ptr);
    for j=1:pte % loop over test examples
        for k=1:ptr % loop over training examples
            x_test=X_test(j,idxf(k,:));
            D2local(j,k)=sum((X_train(k,:)-x_test).^2);
        end
    end
end

Kmax=max(K);
TopP=get_submat(D2local,idxp(:,1:Kmax));
TopN=get_submat(D2local,idxn(:,1:Kmax));
 
p_test=size(X_test,1);
Y_hat=zeros(p_test,num_K);
dp=zeros(p_test,1); dn=zeros(p_test,1); % Sum dist to pos and neg ex.
for i=1:num_K
    if i==1, mini=1; else mini=K(i-1)+1; end
    dp=dp+sum(TopP(:,mini:K(i)),2);
    dn=dn+sum(TopN(:,mini:K(i)),2);
    Y_hat(:,i)=(dn-dp)./(dn+dp);
end

errate=zeros(num_K,1);
if ~isempty(Y_test)
    for i=1:num_K
        ro=Y_hat(:,i).*Y_test;
        errate(i)=mean(ro<=0);
    end
end
        
        
return