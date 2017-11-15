function [dat, alg] =  training(alg,dat)
%[dat, alg] =  training(alg,dat)
% Compute the signal to noise ratio correlation coefficient
% and rank the features accordingly.
% Returns the training data matrix dat restricted to the
% selected features (i.e. feat_num<=feat_max and w>w_min.

% Isabelle Guyon -- isabelle@clopinet.com -- September 2005
  
if (exist(alg.cache_file, 'file') || exist([alg.cache_file '.mat'], 'file'))
    if alg.algorithm.verbosity>0
        fprintf('Loading: %s\n', alg.cache_file);
    end
    load(alg.cache_file);
else
    if alg.algorithm.verbosity>0
        disp(['training ' get_name(alg) '... '])
    end
    X=get_x(dat);
    Y=get_y(dat);
    idx_pos=find(Y>0);
    idx_neg=find(Y<0);
    mu_pos=eps+median(X(idx_pos,:));
    mu_neg=eps+median(X(idx_neg,:));
    if alg.is_log
        W=abs(mu_pos-mu_neg);
    else
        W=max(mu_pos./mu_neg, mu_neg./mu_neg);
    end
    [WS, idx]=sort(-W);
    
    % Cache results
    if ~isempty(alg.cache_file)
        save(alg.cache_file, 'idx', 'W');
    end
end

alg.fidx=idx;
alg.W=W;

dat=test(alg, dat);
  

  

  
  
