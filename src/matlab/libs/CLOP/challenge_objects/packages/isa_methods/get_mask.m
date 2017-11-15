function mask=get_mask(v, num_feat)
%mask=get_mask(v, num_feat)
% Get a digit mask with a given feature number from a feature score vector.

% Isabelle Guyon -- isabelle@clopinet.com -- June 2004

[vv,vi]=sort(-v);
bi=vi(1:num_feat);
M=zeros(size(v));
M(bi)=1;
mask=reshape_digit(M);