function [dat, alg] =  training(alg,dat)
%[dat, alg] =  training(alg,dat)
% Compute the Random Forest ranking
% and rank the features accordingly.
% Returns the training data matrix dat restricted to the
% selected features (i.e. feat_num<=feat_max and w>w_min.

% Isabelle Guyon -- isabelle@clopinet.com -- September 2005
  
  if alg.algorithm.verbosity>0
    disp(['training ' get_name(alg) '... '])
  end
  
  % Train the random forest.
  [ndat, alg.child]=train(alg.child, dat);
  % Here we save the forest... in the rffs model (heavy?)
  
  alg.W=alg.child.forest.errimp;
  [score_feat, alg.fidx]=sort(-alg.W);
  
  dat=test(alg, dat);
  

  

  
  
