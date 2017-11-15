function [Y_hat, K, errate, D2global, D2local]=knnclass2(X_train, Y_train, X_test, Y_test, K, D2global, D2local, idxf)
%[Y_hat, K, errate, D2global, D2local]=knnclass2(X_train, Y_train, X_test, Y_test, K, D2global, D2local, idxf)
% K nearest neighbor classifier for 2-class problems.
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
% idxf      --  Indices of features.
% Returns:  
% Y_hat     --  Prediction values, dim (p_test, num_K).
% errate    --  Resuling error rates (if Y_test is provided), dim num_K.
% D2global  --  Matrix of distances between patterns.
% D2local   --  Matrix of distances between patterns, in idxf projection.

% Isabelle Guyon -- October 2003 -- isabelle@clopinet.com
% May 2005: local scoring with features.

closest=1; % Index of the closest neighbor (2 if no test set for the leave-one-out).
if nargin<4, Y_test=[]; end
if nargin<3 | isempty(X_test), closest=2; X_test=X_train; Y_test=Y_train; end
pos_num=length(find(Y_train==1));
neg_num=length(find(Y_train==-1));
max_num=min(max(pos_num,neg_num),1000);
if nargin<5 | isempty(K), K=2.^[0:floor(log2(max_num))]'; end
if nargin<6, D2global=[]; end
if nargin<7, D2local=[]; end
if nargin<8, idxf=1:size(X_train,2); end

max_val=500000; % to prevent out of memory problems 12000000
dim1=size(X_train,1);
dim2=size(X_test,1);
dim2_max=floor(max_val/dim1);
k=1;
ll=1;
rng={};
while ll<dim2 % Split the test set into chunks
    lu=min(ll+dim2_max, dim2);
    rng{k}=ll:lu;
    k=k+1;
    ll=lu+1;
end

num_K=length(K);

Y_hat=[];
fprintf('Number of test examples %d\n', dim2);
fprintf('Number of chunks %d\n', length(rng));
for k=1:length(rng)
    %fprintf('Chunk %d\n', k);
    X_te=X_test(rng{k},:);
    % Similarity matrix in original space
	if isempty(D2global),
        uv = X_train*X_te';
		uu = (X_train.*X_train)*(0.5*ones(size(X_train,2),1));
		uu2 = repmat(uu,1,size(X_te,1));
		vv = (X_te.*X_te)*(0.5*ones(size(X_train,2),1));
		vv2 = repmat(vv,1,size(X_train,1));
		D2global = uu2' - uv' + vv2;
    end
    % Take care of leave-one-out is train=test
    if closest==2;
        D2global(find(D2global==0))=Inf;
    end
    [val,idx]=sort(D2global,2);
    %for t=1:10,
    %    fprintf('%d %d\n',Y_test(t), Y_train(idx(t,1)));
    %end
    % Look for K closest in each class
    pos_idx=find(Y_train>0);
    neg_idx=find(Y_train<0);
	[valp,idxp]=sort(D2global(:,pos_idx),2);
    idxp=pos_idx(idxp);
    [valn,idxn]=sort(D2global(:,neg_idx),2);
    idxn=neg_idx(idxn);
    %for t=1:10,
    %    fprintf('%d %g\n', Y_test(t), (valn(t,1)-valp(t,1))/(valn(t,1)+valp(t,1)));
    %end
    % Similarity matrix in feature space
    X_te=X_test(rng{k},idxf);
    X_tr=X_train(:,idxf);
	if isempty(D2local),
        uv = X_tr*X_te';
		uu = (X_tr.*X_tr)*(0.5*ones(size(X_tr,2),1));
		uu2 = repmat(uu,1,size(X_te,1));
		vv = (X_te.*X_te)*(0.5*ones(size(X_tr,2),1));
		vv2 = repmat(vv,1,size(X_train,1));
		D2local = uu2' - uv' + vv2;
    end
    Kmax=max(K);
    TopP=get_submat(D2local,idxp(:,1:Kmax));
    TopN=get_submat(D2local,idxn(:,1:Kmax));
    %for t=1:10, 
    %    fprintf('Y_test=%d, Y_hat_local=%g\n', ...
    %        Y_test(t), (TopN(t,1)- TopP(t,1))/(TopN(t,1)+ TopP(t,1)));
    %end
    % Compute local scores
	p_test=size(X_te,1);
	Y_hat_partial=zeros(p_test,num_K);
    dp=zeros(p_test,1); dn=zeros(p_test,1); % Sum dist to pos and neg ex.
	for i=1:num_K
        if i==1, mini=1; else mini=K(i-1)+1; end
        dp=dp+sum(TopP(:,mini:K(i)),2);
        dn=dn+sum(TopN(:,mini:K(i)),2);
        Y_hat_partial(:,i)=(dn-dp)./(dn+dp);
	end
    Y_hat=[Y_hat ; Y_hat_partial];
    if dim2>dim2_max, D2=[]; end % Cannot return the entire D2 because it was not all kept in memory.
end

errate=zeros(num_K,1);
if ~isempty(Y_test)
    for i=1:num_K
        ro=Y_hat(:,i).*Y_test;
        errate(i)=mean(ro<=0);
    end
end
        
        
return