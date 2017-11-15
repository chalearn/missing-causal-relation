function check_data(X, pat_num, feat_num, check_sum)
%check_data(X, pat_num, feat_num, check_sum)
% Function that checks the sanity of the data.

% Isabelle Guyon -- August 2003 -- isabelle@clopinet.com

if any(size(X)~=[pat_num feat_num]), error('Wrong matrix dimension'); end
S=sum(sum(X));
if abs(S-check_sum)>10^-10, warning('Bad check sum %f, instead of %f\n', S, check_sum ); end