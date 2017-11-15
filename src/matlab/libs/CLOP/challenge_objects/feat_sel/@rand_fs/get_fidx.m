function good_idx=get_fidx(alg)
%good_idx=get_fidx(alg)
% Returns the indices of the top ranking features.
% (i.e. rank<=feat_max and w>w_min.)

good_idx=alg.fidx;
