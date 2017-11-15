function [d1, d2, sel] = partition(d, sel, p)

% PARTITION - partition a JOINT_DATA object randomly or deterministically

inp = d.X;
n = get_dim(inp{1});
sel = sel(:);
if ischar(sel)
    if ~strcmp(lower(sel'), 'rand'), error(['unknown option ''' sel' '''']), end
    if nargin < 3, p = 0.5; end
    if ~isnumeric(p) | prod(size(p)) ~= 1, error('P must be a numeric scalar'), end
    p = full(real(double(p)));
    if p < 0
end
if islogical(sel)
    if length(sel) ~= n
if isempty(Y)
if nargout < 2, return, end