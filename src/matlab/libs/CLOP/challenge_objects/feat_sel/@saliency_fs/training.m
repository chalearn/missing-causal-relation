function [dat, alg] =  training(alg,dat)
%[dat, alg] =  training(alg,dat)
% Compute the saleincy as the ratio of the feature median over the overall
% median.
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
    % Y is NOT used for saliency
    med=median(X);
    Med=median(med);
    if alg.is_log
        W=med-Med;
    else
        W=med/(Med+eps);
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
  

  

  
  
