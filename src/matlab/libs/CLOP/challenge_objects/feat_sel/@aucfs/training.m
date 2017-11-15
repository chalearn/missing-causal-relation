function [dat, alg] =  training(alg,dat)
%[dat, alg] =  training(alg,dat)
% Compute the AUC statistic
% and rank the features accordingly.
% Returns the training data matrix dat restricted to the
% selected features (i.e. feat_num<=feat_max and w>w_min.

% Isabelle Guyon -- isabelle@clopinet.com -- December 2005
  
if alg.algorithm.verbosity>0
    disp(['training ' get_name(alg) '... '])
end
 
[p,n]=get_dim(dat);

X=get_x(dat);
Y=get_y(dat);

[idx_feat, score_feat, pval, fdr]=auc_feat_select(X, Y);
alg.fidx=idx_feat;
alg.W(idx_feat)=score_feat;
alg.pval(idx_feat)=pval;
alg.fdr(idx_feat)=fdr
  
if ~alg.algorithm.do_not_evaluate_training_error
    dat=test(alg, dat);
end

  

  

  
  
