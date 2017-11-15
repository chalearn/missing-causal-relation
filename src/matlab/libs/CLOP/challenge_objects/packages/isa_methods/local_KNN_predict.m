function [Y_resu, Y_conf, name] = local_KNN_predict(X_test, param, idx_feat, X_train, Y_train)
%[Y_resu, Y_conf, name] = local_KNN_predict(X_test, param, idx_feat, X_train, Y_train)
% Nearest neighbor classification.
% Inputs:
% X_test -- Test data matrix of dim (num test examples, num features).
% param -- Classifier parameters, see lambda_trainer.
% idx_feat -- Indices of the features selected.
% X_train -- Training data matrix of dim (num training examples, num features).
%         -- used by some predictors (not lambda though).
% Y_train -- Training labels (num training examples, 1).
%         -- used by some predictors (not lambda though).
% Returns:
% Y_resu -- Matrix of +-1 coumn vector predictions on the test data of dim (num test
%           example, num tries).
% Y_conf -- Associated confidence values (e.g. absolute discriminamt values).
% name   -- Names for each try.

% Isabelle Guyon -- October 2003 -- isabelle@clopinet.com

[p,n]=size(X_test);
if isempty(idx_feat), idx_feat=1:n; end
Y_test=[];
name={};

for i=1:length(param)
    K(i)=param(i).K;
    name={name{:} num2str(K(i))};
    B(:,i)=repmat(param(i).b, size(X_test,1),1);
end
if length(param)==1, name={''}; end

[Y_score, K] = local_knnclass(X_train, Y_train, X_test, Y_test, K,[], idx_feat);
Y_score=Y_score+B;    
[Y_resu, Y_conf] = decide(Y_score, Y_train);
