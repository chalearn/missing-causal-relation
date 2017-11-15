function [Idxs, WS, K, D2] = relief_large(X, Y, feat_num, K, group_feat, nosort, D2, chunk_num)
% [Idxs, WS, K, D2] = relief_large(X, Y, feat_num, K, group_feat, nosort, D2, chunk_num)
% Like Relief bu uses the K nearest hits.
% Inputs:
% X -- Data matrix of patterns in lines and features in columns.
% Y -- Target values (length of size(X,1)).
% feat_num -- Desired number of features.
% K -- Number of neighbors considered.
% group_feat -- method to group peaks uesed for mass spectra.
% nosort -- optional flag; if 1, do not sort the features.
% Returns:
% Idxs -- sorted indices.
% WS -- corresponding weights.
% If several values of K are provided, Idxs and WS are matrices with K_num rows.
% K  -- Values tried (useful if K=[] was provided as input.
% D2 -- Squared distance matrix.

% Isabelle Guyon -- July 2003 -- isabelle@clopinet.com

[p, n]=size(X);
pos_idx=find(Y>0);
neg_idx=find(Y<=0);
pos_num=length(pos_idx);
neg_num=length(neg_idx);
if nargin<3 || isempty(feat_num), feat_num=n; end
max_num=min(min(pos_num,neg_num),256);
if nargin<4 || isempty(K), K=2.^[0:floor(log2(max_num))]'; end
if nargin<5 || isempty(group_feat), group_feat=0; end
if nargin<6; nosort=0; end
if nargin<7, D2=[]; end
if nargin<8, chunk_num=[]; end

feat_num=min(n,feat_num);

dim=max(size(X,1));
if isempty(chunk_num)
    max_val=500000; % to prevent out of memory problems 500000
    dim_max=floor(max_val/dim);
else
    dim_max=ceil(dim/chunk_num);
end
k=1;
ll=1;
rng={};
while ll<dim % Split the test set into chunks
    lu=min(ll+dim_max, dim);
    rng{k}=ll:lu;
    k=k+1;
    ll=lu+1;
end

fprintf('Number of examples %d\n', dim);
fprintf('Number of chunks %d\n', length(rng));
nearest_hit=[];
nearest_miss=[];
p1=length(rng{1});
KK=max(K);
for k=1:length(rng)
    fprintf('D2: Chunk %d\n', k);
     Xp=X(rng{k},:);
     Yp=Y(rng{k});
     pp=length(rng{k});
    % Compute the partial distance matrix
	if isempty(D2),
        uv = Xp*X';
		uu = (Xp.*Xp)*(0.5*ones(size(Xp,2),1));
		uu2 = repmat(uu,1,size(X,1));
		vv = (X.*X)*(0.5*ones(size(Xp,2),1));
		vv2 = repmat(vv,1,size(Xp,1));
		D2 = uu2 - uv + vv2';
	end
	% Eliminate diagonal 
	for j=1:pp, D2(j,j+p1*(k-1))=Inf; end
    % Find nearest hits and nearest misses
	partial_nearest_hit=zeros(pp,KK);
	partial_nearest_miss=zeros(pp,KK);
	for j=1:pp
        if Yp(j)>0
            [d, id]=sort(D2(j,pos_idx)); partial_nearest_hit(j,:)=pos_idx(id(1:KK))';
            [d, id]=sort(D2(j,neg_idx)); partial_nearest_miss(j,:)=neg_idx(id(1:KK))';
        else
            [d, id]=sort(D2(j,pos_idx)); partial_nearest_miss(j,:)=pos_idx(id(1:KK))';
            [d, id]=sort(D2(j,neg_idx)); partial_nearest_hit(j,:)=neg_idx(id(1:KK))';
        end
	end
    nearest_hit=[nearest_hit; partial_nearest_hit];
    nearest_miss=[nearest_miss; partial_nearest_miss];
    if dim>dim_max, D2=[]; end % Cannot return the entire D2 because it was not all kept in memory.
end

% Compute the feature scores in projection:
nh=0;
nm=0;
K_num=length(K);
M=zeros(K_num, size(X,2)); % Average distances to nearest misses
H=zeros(K_num, size(X,2)); % Average distances to nearest hits
for j=1:K_num
    if j==1, mini=1; else mini=K(j-1)+1; end
	for i=mini:K(j)
        %rnm=0;
        %rnh=0;
        %for k=1:p
        %    rnm=run_ave(rnm, abs(X(k,:)-X(nearest_miss(k,i),:)),k);
        %    rnh=run_ave(rnh, abs(X(k,:)-X(nearest_hit(k,i),:)),k);
        %end
       rnm=0;
       rnh=0;
       for k=1:length(rng)
           fprintf('nm nh j=%d, i=%d: Chunk %d\n', j, i, k);
           rnm=rnm+mean(abs(X(rng{k},:)-X(nearest_miss(rng{k},i),:)));
           rnh=rnh+mean(abs(X(rng{k},:)-X(nearest_hit(rng{k},i),:)));
       end
        nm=nm+rnm;
        nh=nh+rnh;
	end
	M(j,:)=nm;
    H(j,:)=nh;   
end
H(M==0)=1;
H(H==0)=eps;
W=M./H;

if ~nosort
    [WW, II]=sort(-W,2);
    if group_feat,
        Idxs=feat_group(II, -WW, feat_num)';
    else
        Idxs=II(:,1:feat_num);
    end
    WS=-WW(:,1:feat_num);
else
    Idxs(j,:)=repmat([1:feat_num],K_num,1);
    WS=W;
end 

return




