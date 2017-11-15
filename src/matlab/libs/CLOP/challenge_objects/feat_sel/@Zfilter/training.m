function [dat, alg] =  training(alg,dat)
%[dat, alg] =  training(alg,dat)
% Compute the T statistic
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

alg.W=sum(X~=0);
[ss,alg.fidx]=sort(-alg.W);
  
if ~alg.algorithm.do_not_evaluate_training_error
    dat=test(alg, dat);
end

  

  

  
  
