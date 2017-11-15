function W = set_w(a, W) 
%W = set_w(a, W) 
% Sets the weight vector of the model, if it exists.

% Isabelle Guyon -- isabelle@clopinet.com -- October 2005

W=[];
if isfield(a, 'W')
    a.W=W;
end

