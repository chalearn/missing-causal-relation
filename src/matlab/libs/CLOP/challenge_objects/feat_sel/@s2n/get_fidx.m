function good_idx=get_fidx(alg)
%good_idx=get_fidx(alg)
% Returns the indices of the top ranking features.
% (i.e. rank<=feat_max and w>w_min.)

good_idx=alg.fidx;

% Apply first the thresholds:
w_idx=find(abs(alg.W)>alg.w_min);
good_idx=intersect(good_idx, w_idx);

% Cut the length
n=min(length(good_idx), alg.f_max);
W_good=alg.W(good_idx); % Always sort /Dec 20, 2005/
[Ws, Wi]=sort(-W_good);
nn=length(Wi);
if alg.balance==1
    % This is a special case in which we put 1/2 positively correlated
    % features and 1/2 negative;y correlated features (Dec 2012)
    fn=ceil(n/2);
    if fn==n/2
        idx=[1:fn,nn-fn+1:nn];
    else
        idx=[1:fn,nn-fn+2:nn];
    end
    good_idx=good_idx(Wi(idx));
elseif alg.balance>1   
    % This is the special case in which we have 1/4 positively correlated
    % 1/4 negatively correlated and 1/2 non-correlated (in the middle)
    fn=round(n/4);
    if fn~=n/4
        error('We want a multiple of 4 features');
    end
    [w, mid_idx]=sort(abs(Ws));
    mid_idx=mid_idx(1:2*fn);
    idx=[1:fn, mid_idx, nn-fn+1:nn];
    good_idx=good_idx(Wi(idx));
else
    % This is rhe regular case
    good_idx=good_idx(Wi(1:n));
end
