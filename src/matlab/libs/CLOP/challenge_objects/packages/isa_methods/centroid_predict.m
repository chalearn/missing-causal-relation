function [Y_resu, Y_proba] = centroid_predict(X_test, param, idx_feat)
%[Y_resu, Y_proba] = centroid_predict(X_test, param, idx_feat)
% Centroid classification.
% Inputs:
% X_test -- Test data matrix of dim (num test examples, num features).
% param -- Classifier parameters, see lambda_trainer.
% idx_feat -- Indices of the features selected.
% Returns:
% Y_resu -- Matrix of +-1 predictions on the test data of dim (num test
%           x class num).
% Y_proba -- Posterior probabilities for each class.

% Isabelle Guyon -- October 2015 -- isabelle@clopinet.com

[p,n]=size(X_test);
if nargin<3 || isempty(idx_feat), idx_feat=1:n; end

cnum = size(param.X, 1);
Y_resu = -ones(p, cnum);
Y_proba = zeros(p, cnum);

% Compute posterior probabilities
if ~isempty(param.V)
    for k=1:cnum
        mu = param.X(k,:);
        va = param.V(k,:);
        Y_proba(:,k) = exp (-0.5* sum((X_test - mu(ones(p,1),:)).^2 ./ va(ones(p,1),:), 2));
    end
    % Normalize
    norma = sum ( Y_proba, 2);
    Y_proba =  Y_proba ./ norma(:, ones(cnum, 1));
else

    % Compute distances
    D = Inf*ones(p, cnum);
    for k=1:cnum
        mu = param.X(k,:);
        D(:,k) = sum((X_test - mu(ones(p,1),:)).^2, 2);
    end
end

% Compute the best class
for i=1:p
    if ~isempty(param.V)
        [m, j]=max(Y_proba(i,:));
    else
        [m, j]=min(D(i,:));
    end
    Y_resu(i, j) = 1;
end


