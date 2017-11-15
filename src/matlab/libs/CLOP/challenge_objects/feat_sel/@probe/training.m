function [dat, alg] =  training(alg,dat)
%[dat, alg] =  training(alg,dat)
% Compute the ranking criterion for the data and the probes
% and rank the features accordingly.
% Returns the training data matrix dat restricted to the
% selected features (i.e. feat_num<=feat_max and w>w_min.
% The model includes the pvalues and fdr computed by the probe method.

% Isabelle Guyon -- isabelle@clopinet.com -- December 2005
  
if alg.algorithm.verbosity>0
    disp(['training ' get_name(alg) '... '])
end

[p,n]=get_dim(dat);

% Remove limits on the number of features 
alg.child.f_max=Inf;
alg.child.w_min=-Inf;

% compute ranking
[dt, alg.child]=train(alg.child, dat);
clear dt
alg.W=get_w(alg.child); %alg.child.W;
alg.fidx=get_fidx(alg.child); %alg.child.fidx;

% random probe for pval and fdr
if alg.algorithm.verbosity>0
    disp(['Evaluating pval with probe, be patient... '])
end
rdat=rand_probe(dat, alg.p_num);
[rdat, ralg]=train(alg.child, rdat); 
%sorted_pval=pval_compute(alg.W(alg.fidx), ralg.W(ralg.fidx));
sorted_pval=pval_compute(alg.W(alg.fidx), get_w(ralg,1));
inv_idx(alg.fidx)=1:n;
alg.pval=sorted_pval(inv_idx);
sorted_fdr=sorted_pval.*(n./[1:n]);
alg.fdr = sorted_fdr(inv_idx);

% Limit the number of features as desired
alg.child.f_max=alg.f_max;
alg.child.w_min=alg.w_min;

if ~alg.algorithm.do_not_evaluate_training_error
    dat=test(alg, dat);
end  

  

  
  
