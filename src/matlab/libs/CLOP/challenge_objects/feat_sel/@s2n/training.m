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
    if alg.balance
        fprintf('S2N training in a balanced way\n');
        [idx,W]=golub_feat(get_x(dat), get_y(dat),[],[],1);
    else
        [idx,W]=golub_feat(get_x(dat), get_y(dat));
    end
    
    % Cache results
    if ~isempty(alg.cache_file)
        save(alg.cache_file, 'idx', 'W');
    end
end

alg.fidx=idx;
alg.W=[];
alg.W(alg.fidx)=W;

dat=test(alg, dat);
  

  

  
  
