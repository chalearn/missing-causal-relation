function sorted_pval = pval_compute(sorted_w, sorted_rand_w)
%sorted_pval = pval_compute(sorted_w, sorted_rand_w)
% Computes pvalues for all the values of the criterion w of the features,
% given values of the same criterion for random features (probes).
% Inputs:
% sorted_w      --    Sorted weights of features, best come first (can handle multiple ranked lists
% each list being a line of the matrix.)  Dim = [p, n], n=number of
% features.
% sorted_rand_w --    Sorted weights of random probes (if there are multiple lists, the number of lists should
% be the same ae that of sorted_w.) Dim = [p, n'], n'=number of probes.
% Returns:
% sorted_pval   --    Fraction of random probes that have a larger w value.

% Note: this differs from computing the false discovery rate FDR
% that is the fraction of falsely significant features above value of w. 
% FDR=pval*i/n, where i is the feature rank and n the total number of features.

% Isabelle Guyon -- October 2003 -- isabelle@clopinet.com

if nargin<2, error('Too few arguments'); help('pval_compute'); end

[p,n]=size(sorted_w);
[pr,nr]=size(sorted_rand_w);
if nr==0, sorted_pval=[]; return; end
if pr ~= p, error('Number of ranked lists differ'); end
sorted_pval=zeros(size(sorted_w));
for k=1:p
	sorted_pval_old=1;
	for i=n:-1:1
        w=sorted_w(k,i);
        [wd, ir]=min(abs(sorted_rand_w(k,:)-w));
        sorted_pval(k,i)=(ir-1)/nr;
        if sorted_pval(k,i)>sorted_pval_old
            sorted_pval(k,i)=sorted_pval_old;
        end
        sorted_pval_old=sorted_pval(k,i);
	end
end
return