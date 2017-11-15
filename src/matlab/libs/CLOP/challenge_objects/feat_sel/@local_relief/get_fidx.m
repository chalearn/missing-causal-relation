function good_idx=get_fidx(alg)
%good_idx=get_fidx(alg)
% Returns the indices of the top ranking features.
% (i.e. rank<=feat_max and w>w_min.)

good_idx=alg.fidx;

% Apply first the thresholds:
%w_idx=find(alg.W>alg.w_min);
%good_idx=intersect(good_idx, w_idx);

% Cut the length
%n=min(length(good_idx), alg.f_max);
%W_good=alg.W(good_idx); % Always sort /Dec 20, 2005/
%[Ws, Wi]=sort(-W_good);
%good_idx=good_idx(Wi(1:n));

n=min(size(good_idx, 2), alg.f_max);
good_idx=good_idx(:,1:n);
