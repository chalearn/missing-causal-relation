function [retDat,algo] =  training(algo,retDat)
%[retDat,algo] =  training(algo,retDat)
% Train a Naive Bayes classifier.
% Inputs:
% algo -- A Naive Bayes classifier object.
% retDat -- A training data object.
% Returns:
% retDat -- The same data structure, but X is replaced by the class label
% predictions on training data.
% algo -- The trained Naive Bayes classifier.

% Isabelle Guyon -- September 2005 -- isabelle@clopinet.com
% Modified October 2015 (add multiclass centroid method)

if algo.algorithm.verbosity>0
    disp(['training ' get_name(algo) '... '])
end

X=get_x(retDat); 
Y=get_y(retDat); 
[p,n]=size(X);
[p,c]=size(Y);

% Check the nature of the features
featval=full(unique(X(:)));
targval=full(unique(Y(:)));

if c>1 || length(targval)>2,
	algo.binary = -1; % multiclass case
elseif p*n>2 && length(featval)==2
    algo.binary=1;
    if ~(min(featval)==0 & max(featval)==1)
        X(find(X==min(featval)))=0;
        X(find(X==max(featval)))=1;
        if algo.algorithm.verbosity>0
            fprintf('Binary values found, converted to 0/1\n');
        end
    end
else
    algo.binary=0;
end
    
if algo.binary > 0
    fprintf('Running binary version...\n');
    param=naivebayes(X, Y);
    algo.W=param.W; algo.b0=param.b;
elseif algo.binary < 0
    fprintf('Running multiclass centroid algorithm...\n');
    param=centroid_train(X, Y);
    algo.W = param;
else
    fprintf('Running Gaussian model version...\n');
    param=gaussian_train(X, Y);
    algo.W=param.W; algo.b0=param.b;
end

if algo.algorithm.do_not_evaluate_training_error
    retDat=set_x(retDat,get_y(retDat)); 
else
    retDat=test(algo,retDat);
end
        








