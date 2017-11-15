function b0 = get_b0(a,method) 
%b0 = get_b0(a) 
% Returns the weight vector from the model, if it exists.

% Isabelle Guyon -- isabelle@clopinet.com -- October 2005

b0=[];
if isfield(a, 'b0')
    b0=a.b0;
end

