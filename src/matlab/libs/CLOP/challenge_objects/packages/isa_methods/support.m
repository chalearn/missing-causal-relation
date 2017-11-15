function s=support(digit)
%s=support(digit)
% Compute the length of the vertical projection

% Isabelle Guyon -- isabelle@clopinet.com -- June 2004

% clip:
digit(digit<0.5)=0;
digit(digit>=0.5)=1;

proj=max(digit);
pidx=find(proj==1);
s=max(pidx)-min(pidx);
