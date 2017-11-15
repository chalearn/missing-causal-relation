function b0 = set_b0(a, b0) 
%b0 = set_w(a, b0) 
% Sets the bias of the model, if it exists.

% Isabelle Guyon -- isabelle@clopinet.com -- October 2005

b0=0;
if isfield(a, 'b0')
    a.b0=b0;
end

