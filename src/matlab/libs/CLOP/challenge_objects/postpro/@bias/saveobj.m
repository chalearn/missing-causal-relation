function a = saveobj(a)
%	SAVEOBJ     A method to save ALGORITHM object
% This will be used if no SAVEOBJ has been defined for a specific
% algorithm. This function will try to clear big fields of the given
% algorithm.

% Amir Reza Saffari Azar, amir@ymer.org
% Based on code by Isabelle Guyon -- isabelle@clopinet.com -- October 2005

maxsize = 20000;

b   = struct(a);
fn  = fields(b);

if isfield(b, 'display_fields')
    df  = b.display_fields;
else
    df  = fn;
end

for k = 1:length(fn)
    % Look for "big" fields
    if ~ismember(fn{k}, df) & isnumeric(b.(fn{k})) & (prod(size(b.(fn{k})))>maxsize)
        a.(fn{k})   = [];
    end
end

a.algorithm.saved = 1;
