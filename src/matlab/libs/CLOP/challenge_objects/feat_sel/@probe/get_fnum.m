function len=get_fnum(alg)
%len=get_fnum(alg)
% Returns the number of features selected.
% (i.e. s.t. rank<=feat_max, pval<=pval_max, fdr<=fdr_max and w>w_min.)

good_idx=get_fidx(alg);
len=length(good_idx);



