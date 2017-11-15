function Y = inormalize(X)
%Y = inormalize(X)
% Inputs:
% X -- matrix of reals.
% Retruns:
% Y -- matrix X normalized between 0 and 1.
% If all values are equal, return all ones.

% Isabelle Guyon -- April 2002 -- isabelle@clopinet.com

mini = min(min(X));
maxi = max(max(X));
delta = maxi-mini;
if delta==0,
   [n, p] = size(X);
   Y = ones(n, p);
else
   Y = (X - mini)/delta;
end