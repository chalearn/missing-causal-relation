function [dat, alg] =  training(alg,dat)
%[dat, alg] =  training(alg,dat)
% Compute the Spearman correlation coefficient
% and rank the features accordingly.
% Returns the training data matrix dat restricted to the
% selected features (i.e. feat_num<=feat_max and w>w_min.

% Isabelle Guyon -- isabelle@clopinet.com -- Oct 2012
  
if alg.algorithm.verbosity>0
    disp(['training ' get_name(alg) '... '])
end
 
[p,n]=get_dim(dat);

X=get_x(dat);
Y=get_y(dat);

W=zeros(1,n);
pval=ones(1,n);

for k=1:n
    % Replace column by rank of values 
    X(:,k)=tiedrank(X(:,k));
    if(var(X(:,k))~=0)
        [R, P]=corrcoef(X(:,k),Y);
        W(k)=R(1,2);
        pval(k)=P(1,2);
        %If you are confused about how these pvalues are computed. Explanations are found in Chapter 2, page 71 and in the Matlab manual:
        %>doc corrcoef
        %>help corrcoef
    end
end
alg.w=W;
alg.W=abs(W);
[ss,alg.fidx]=sort(-alg.W);
alg.pval = pval;
sorted_fdr=alg.pval(alg.fidx).*(n./[1:n]);
alg.fdr(alg.fidx) = sorted_fdr;
  
if ~alg.algorithm.do_not_evaluate_training_error
    dat=test(alg, dat);
end

  

  

  
  
