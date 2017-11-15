function [dat, alg] =  training(alg,dat)
%[dat, alg] =  training(alg,dat)
% Compute the signal to noise ratio correlation coefficient
% and rank the features accordingly.
% Returns the training data matrix dat restricted to the
% selected features (i.e. feat_num<=feat_max and w>w_min.

% Isabelle Guyon -- isabelle@clopinet.com -- April 2013
  
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
    y=get_y(dat);
    
    % If primary predictors are provided
    if ~isempty(alg.child)
        % Project the genes on the null space of the contrast direction
        S=alg.child.X;
        % Normalize to get the projection operator
        P=S*pinv(S'*S)*S';
        % Get the complement of the projection (projection onto null space)
        X=X-P*X;
        % Problem: the primary predictor projections are not exactly 0
        % (numerical reasons)
        v=var(X);
        z=find(v<eps);
        X(:,z)=zeros(size(X, 1), length(z));
    end
        
    if length(unique(y))==2
        % Classification problem
        [idx,W]=golub_feat(X, y);
        W(idx)=W;
        fprintf('Classification case\n');
    else
        n=size(X, 2);
        W=zeros(1,n);
        for k=1:n
            if(var(X(:,k))>eps)
                R=corrcoef(X(:,k),y);
                W(k)=abs(R(1,2));
            end
        end     
        fprintf('Regression case\n');
    end
    if ~isempty(alg.child)
        [~, idx]=sort(-W); % Keep the most correlated contrast features
    else
        [~, idx]=sort(W); % Keep the least correlated calibrant
    end
    
    % Cache results
    if ~isempty(alg.cache_file)
        save(alg.cache_file, 'idx', 'W');
    end
end

alg.fidx=idx;
alg.W=[];
alg.W(alg.fidx)=W;
alg.f_max=min(alg.f_max, length(W));

dat=test(alg, dat);
  

  

  
  
