function pval=get_fdr(alg, method)
%pval=get_fdr(alg, method)
% Returns all the pvalues.
% If method is given, return only the top ranking values.

pval=alg.fdr;
if nargin>1
    pval=pval(get_fidx(alg));
end