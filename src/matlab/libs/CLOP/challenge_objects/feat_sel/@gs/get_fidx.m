function good_idx=get_fidx(alg)
%good_idx=get_fidx(alg)
% Returns the indices of the top ranking features.
% (i.e. rank<=feat_max and w>w_min.)

feat_idx=[];
n=length(alg.fidx);
good_idx=alg.fidx(1:min(n,alg.f_max));
W_good=alg.W(good_idx);
good_idx=good_idx(find(W_good>alg.w_min));