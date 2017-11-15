function d = test(a, d)
%d = test(a, d)
% Make predictions with the linear discriminant method.
% Inputs:
% a -- A linear discriminant model.
% d -- A data structure.
% Returns:
% d -- The same data structure, but X is replaced by the discriminant
% values.

% Isabelle Guyon -- September 2005 -- isabelle@clopinet.com

[p, n]=size(d.X);

Yest = d.X*a.W' + a.b0(ones(p,1),:);

d.X=Yest; 