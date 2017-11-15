function is_ok=check_range(a, value)
%is_ok=check_range(a, value)
% Checks value belongs to the value range.

is_ok=1;

if isempty(a.valuerange) | isempty(value), return; end

if isnumeric(a.valuerange)
    minval=a.valuerange(1);
    maxval=a.valuerange(2);
    if value<minval | value>maxval
        is_ok=0;
    end
elseif isnumeric(value)
    valset=[];
    for k=1:length(a.valuerange)
        valset(k)=a.valuerange{k};
    end
    if ~ismember(value, valset)
        is_ok=0;
    end    
else % should be a cell array
    if ~ismember(value, a.valuerange)
        is_ok=0;
    end
end