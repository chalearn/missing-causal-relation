function good_idx=get_fidx(alg)
%good_idx=get_fidx(alg)
% Returns the indices of the top ranking features.
% (i.e. rank<=feat_max, pval<=pval_max, fdr<=fdr_max and w>w_min.)

good_idx=alg.fidx;

% Apply first the thresholds:
w_idx=find(alg.W>alg.w_min);
good_idx=intersect(good_idx, w_idx);

pval_idx=find(alg.pval<=alg.pval_max);
good_idx=intersect(good_idx, pval_idx);

fdr_idx=find(alg.fdr<=alg.fdr_max);
good_idx=intersect(good_idx, fdr_idx);

% Cut the length
n=min(length(good_idx), alg.f_max);
W_good=alg.W(good_idx); % Always sort /Dec 20, 2005/
[Ws, Wi]=sort(-W_good);
good_idx=good_idx(Wi(1:n));



