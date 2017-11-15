function [dat, alg] =  training(alg,dat)
%[dat, alg] =  training(alg,dat)
% Compute the signal to noise ratio correlation coefficient
% and rank the features accordingly.
% Returns the training data matrix dat restricted to the
% selected features (i.e. feat_num<=feat_max and w>w_min.

% Isabelle Guyon -- isabelle@clopinet.com -- September 2005
  
  if alg.algorithm.verbosity>0
    disp(['training ' get_name(alg) '... '])
  end
  
  X=get_x(dat);
  const_feat=find(all(X(ones(size(X,1),1),:)==X));
  alg.W=ones(1, size(X,2));
  alg.W(const_feat)=0;
  [Ws, alg.fidx]=sort(-alg.W);
  
  dat=test(alg, dat);
  

  

  
  
