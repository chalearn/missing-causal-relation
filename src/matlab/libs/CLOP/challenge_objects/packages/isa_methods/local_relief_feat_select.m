function [idx_feat, score_feat, pval]=local_relief_feat_select(X, Y, feat_num, pval_max, probe_num)
%[idx_feat, score_feat, pval]=local_relief_feat_select(X, Y, feat_num, pval_max, probe_num)
% Feature selection with the Relief method.
% Inputs:
% X             -- Training data matrix of dim (p, n), patterns in rows, features in columns.
% Y             -- Target values (+-1) of dim (p,1).
% feat_num      -- Desired number of features.
% pval_max      -- Maximum pvalue allowed (has also consequences on the number of features).
% probe_num     -- Number of random probes used.
% Returns:
% idx_feat      -- Indices of the selected features (as many lines as
% patterns, becaus local.)
% score_feat    -- Corresponding scores (larger for better features).
% pval          -- Corresponding p values computed with the random probes.

% Isabelle Guyon -- September 2003 -- isabelle@clopinet.com

[p, n]=size(X);
debug=0;

if nargin<3 | isempty(feat_num), feat_num=n; end
if nargin<4 | isempty(pval_max), pval_max=1; end
if nargin<5 | isempty(probe_num), probe_num=10000; end %probe_num=min(feat_num,10000);

% Compute the scores
K=4; %K=[]; % If K is not precised, a bunch of K's are tried. Matrices are returned.
group_feat=0;
[idx_feat, score_feat, K] = local_relief_large(X, Y, feat_num, K, group_feat);

% Draw rnum random probes to assess p values
if nargout>2
    RX=rand_probe(X, probe_num);
    [idx_probe, score_probe] = local_relief_large(RX, Y, [], K, group_feat);
    pval=pval_compute(score_feat, score_probe);
    for k=1:length(K)
        save_outputs(['reliefK' num2str(K(k)) '.pval'], pval(k,:));
    end
else
    pval=ones(size(idx_feat));
end
if debug
lg={};
    for i=1:length(K), lg={lg{:}, num2str(K(i))}; end
    figure; plot(pval');
    legend(lg,-1);
end
% Keep only the values lower than pvalmax for any of the K.
%if length(K)==1
%    idx_val=find(pval<=pval_max);
%else
%    idx_val=find(any(pval<=pval_max));
%end
%idx_feat=idx_feat(:,idx_val);
%score_feat=score_feat(:,idx_val);
%pval=pval(:,idx_val);
 
return






