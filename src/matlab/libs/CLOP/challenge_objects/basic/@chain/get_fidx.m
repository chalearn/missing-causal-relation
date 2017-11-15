function good_idx=get_fidx(alg)
%good_idx=get_fidx(alg)
% Returns the indices of the top ranking features.
% By default, returns []

good_idx=[];
for k=1:length(alg.child)
    new_idx=get_fidx(alg.child{k});
    if ~isempty(new_idx)
        if isempty(good_idx)
            good_idx=new_idx;
        else
            good_idx=good_idx(new_idx);
        end
    end
end
