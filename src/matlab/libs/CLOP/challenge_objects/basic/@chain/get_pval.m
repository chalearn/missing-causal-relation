function pval=get_pval(alg, method)
%pval=get_pval(alg, method)
% Returns all the pvalues.
% If method is given, return only the top ranking values.
% Works only if method is given.

n=length(alg.child);
pval=get_pval(alg.child{n}, 1);
if nargin<=1
    pw=zeros(size(get_fidx(alg.child{1})));
    idx_final=get_fidx(the_model);
    p(idx_final)=pval;
    pval=p;
end