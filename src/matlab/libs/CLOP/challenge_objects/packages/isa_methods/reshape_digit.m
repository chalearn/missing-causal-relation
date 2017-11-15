function digit=reshape_digit(v)
% digit=reshape_digit(v)
% crete a 2d digit matrix from a vector format

% Isabelle Guyon -- isabelle @ clopinet.com -- June 2004

ld=length(v);
nd=sqrt(ld);
digit=reshape(v,nd,nd)';


