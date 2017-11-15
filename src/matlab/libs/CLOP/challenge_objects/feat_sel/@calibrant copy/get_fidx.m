function good_idx=get_fidx(alg)
%good_idx=get_fidx(alg)
% Returns the indices of the top ranking features.

good_idx=alg.fidx(1:alg.f_max);

