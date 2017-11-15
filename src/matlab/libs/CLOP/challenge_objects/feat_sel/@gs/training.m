function [dat, alg] =  training(alg,dat)
%[dat, alg] =  training(alg,dat)
% Compute the Gram-Schmidt ranking.
% and rank the features accordingly.
% Returns the training data matrix dat restricted to the
% selected features (i.e. feat_num<=f_max).

% Isabelle Guyon -- isabelle@clopinet.com -- September 2005
  
  if alg.algorithm.verbosity>0
    disp(['training ' get_name(alg) '... '])
  end
  
  [p,n]=get_dim(dat);
  Numr=0; % number of random probes.
  itnum=min(alg.f_max, n); % number of features
  if alg.algorithm.verbosity>1
      logfile=1;
  else
      logfile=0;
  end
  [W, alg.fidx] = gram_schmidt(get_x(dat), get_y(dat), Numr, itnum, logfile, alg.seed, alg.method);
  alg.W=[];
  alg.W(alg.fidx)=W;
  
  dat=test(alg, dat);
  

  

  
  
