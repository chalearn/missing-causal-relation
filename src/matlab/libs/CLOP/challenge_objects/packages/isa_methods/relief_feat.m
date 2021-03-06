function [idxs, ws, D2] = relief_feat(X, Y, feat_num, K, group_feat, nosort, D)
% [idxs, ws, D2] = relief_feat(X, Y, feat_num, K, group_feat, nosort, D)
% Like Relief bu uses the K nearest hits.
% Inputs:
% X -- Data matrix of patterns in lines and features in columns.
% Y -- Target values (length of size(X,1)).
% feat_num -- Desired number of features.
% K -- Number of neighbors considered.
% group_feat -- method to group peaks uesed for mass spectra.
% nosort -- optional flag; if 1, do not sort the features.
% Returns:
% idxs -- sorted indices.
% ws -- corresponding weights.
% D -- Distance matrix.

% Isabelle Guyon -- July 2003 -- isabelle@clopinet.com

[p, n]=size(X);
if nargin<3 | isempty(feat_num), feat_num=n; end
if nargin<4 | isempty(K), K=1; end
if nargin<5 | isempty(group_feat), group_feat=0; end
if nargin<6; nosort=0; end

feat_num=min(n,feat_num);

% Compute the squared distance matrix
if nargin<7,
    xxp = X*X'; 
    xx = (X.*X)*ones(size(X,2),1);
    xx2 = repmat(xx,1,size(X,1));
    D2 = sqrt(xx2 - 2 * xxp + xx2');
end
       
% Eliminate diagonal relevance
for k=1:p, D2(k,k)=Inf; end

% Find nearest hits and nearest misses
pos_idx=find(Y>0);
neg_idx=find(Y<0);
nearest_hit=zeros(p,K);
nearest_miss=zeros(p,K);
for k=1:p
    if Y(k)>0
        [d, id]=sort(D2(k,pos_idx)); nearest_hit(k,:)=pos_idx(id(1:K))';
        [d, id]=sort(D2(k,neg_idx)); nearest_miss(k,:)=neg_idx(id(1:K))';
    else
        [d, id]=sort(D2(k,pos_idx)); nearest_miss(k,:)=pos_idx(id(1:K))';
        [d, id]=sort(D2(k,neg_idx)); nearest_hit(k,:)=neg_idx(id(1:K))';
    end
end

% Compute the feature scores in projection:
nh=0;
nm=0;
for i=1:K
    nm=nm+mean(abs(X-X(nearest_miss(:,i),:)));
end
for i=1:K
    nh=nh+mean(abs(X-X(nearest_hit(:,i),:)));
end
nh(find(nh==0))=eps;
w=nm./nh;

if ~nosort
    [ws, ii]=sort(-w);
    if group_feat,
        idxs=feat_group(ii, -ws, feat_num)';
    else
        idxs=ii(1:feat_num);
    end
    ws=w(idxs);
else
    idxs=1:feat_num;
    ws=w;
end
return




