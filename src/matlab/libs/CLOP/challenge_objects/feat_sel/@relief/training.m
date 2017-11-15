function [dat, alg] =  training(alg,dat)
%[dat, alg] =  training(alg,dat)
% Compute the Relief coefficients
% and rank the features accordingly.
% Returns the training data matrix dat restricted to the
% selected features (i.e. feat_num<=feat_max and w>w_min.

% Isabelle Guyon -- isabelle@clopinet.com -- September 2005
  
  if alg.algorithm.verbosity>0
    disp(['training ' get_name(alg) '... '])
  end
  
  [alg.fidx,W]=relief_large(get_x(dat), get_y(dat), [], alg.k_num, [],[],[],alg.chunk_num);
  alg.W=[];
  alg.W(alg.fidx)=W;
  
  dat=test(alg, dat);
  

  

  
  
