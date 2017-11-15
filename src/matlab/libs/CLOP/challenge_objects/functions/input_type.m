function t=input_type(Y)
% t=input_type(Y)
% Detects whether the binary values are +-1 or 0,1
% Returns 1 in the first case and zero in the second case.

% Isabelle Guyon -- isabelle@clopinet.com -- April 2008

vals=unique(Y);
if length(vals)~=2, error('unsupported input type, must be binary 0,1 or +-1'); end
if max(vals)~=1, error('unsupported input type, must be binary 0,1 or +-1'); end
if min(vals)==-1
    t=1;
elseif min(vals)==0
    t=0;
else
    error('unsupported input type, must be binary 0,1 or +-1');
end