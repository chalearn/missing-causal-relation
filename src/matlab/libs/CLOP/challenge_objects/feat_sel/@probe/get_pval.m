function pval=get_pval(alg, method)
%pval=get_pval(alg, method)
% Returns all the pvalues.
% If method is given, return only the top ranking values.

pval=alg.pval;
if nargin>1
    pval=pval(get_fidx(alg));
end
