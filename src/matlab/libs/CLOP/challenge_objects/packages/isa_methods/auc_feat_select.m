function [idx_feat, score_feat, pval, fdr]=auc_feat_select(X, Y, feat_num, pval_max, probe_num)
%[idx_feat, score_feat, pval, fdr]=auc_feat_select(X, Y, feat_num, pval_max, probe_num)
% Feature subset ranking using the AUC criterion method.
% Works only for 2-class problems.
% Uses the Wilcoxon test to compute the pvalues using the equivalence of
% the Wilcoxon test and the Mann-Withney test and the fact that the AUC
% is a normalized Mann-Withney statistic.
% Inputs:
% X             -- Training data matrix of dim (p, n), patterns in rows, features in columns.
% Y             -- Target values (+-1) of dim (p,1).
% feat_num      -- Desired number of features.
% pval_max      -- Unused, use exact statistical test.
% probe_num     -- Unused, use exact statistical test.
% Returns:
% idx_feat      -- Indices of the selected features.
% score_feat    -- Feature score = area under the ROC curve; good if small or large.
% pval          -- Corresponding p values computed with the random probes.
% fdr           -- False discovery rate.

% Isabelle Guyon -- June 2005 -- isabelle@clopinet.com

[p, n]=size(X);
if nargin<3 | isempty(feat_num), feat_num=n; end
if nargin<4 | isempty(pval_max), pval_max=[]; end
if nargin<5 | isempty(probe_num), probe_num=[]; end

pidx=find(Y>0);
nidx=find(Y<0);
p1=length(pidx);
p2=length(nidx);
pval=zeros(1,n);
W=zeros(1,n);
for k=1:n
    warning off
    [pval(k),h,stats]=ranksum(X(pidx,k), X(nidx,k));
    warning on
    %W(k)=stats.ranksum;
    W(k)=abs(stats.zval);
end
%p=min(p1,p2);
%auc=(W-(p*(p+1)/2))./(p1*p2);
%auc=abs(auc-0.5)+0.5;

%[scrit,idx_feat]=sort(pval);
%[scrit,idx_feat]=sort(-auc);
[scrit,idx_feat]=sort(-W);
score_feat=W(idx_feat);
pval=pval(idx_feat);
fdr=pval.*length(pval)./[1:length(pval)];

if (length(idx_feat)>feat_num)
    idx_feat=idx_feat(1:feat_num);
    score_feat=score_feat(1:feat_num);
    pval=pval(1:feat_num);
    fdr=fdr(1:feat_num);
end



