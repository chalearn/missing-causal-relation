function good_idx=get_fidx(alg)
%good_idx=get_fidx(alg)
% Returns the indices of the top ranking features.
% (i.e. rank<=feat_max and w>w_min.)

good_idx=alg.fidx;
% Find the final length
nn=length(good_idx);
n=min(length(good_idx), alg.f_max);

% We cannot apply the thresholds without messing up the order
% so we don't!
if alg.balance==1
    fn=ceil(n/2);
    if fn==n/2
        idx=[1:fn,nn-fn+1:nn];
    else
        idx=[1:fn,nn-fn+2:nn];
    end
    good_idx=good_idx(idx);
else    
    good_idx=good_idx(1:n);
end
