function [retDat,algo] =  training(algo,retDat)
%[retDat,algo] =  training(algo,retDat)
% Train a Kernel logistic classifier.
% Inputs:
% algo -- A Kernel logistic classifier object.
% retDat -- A training data object.
% Returns:
% retDat -- The same data structure, but X is replaced by the class label
% predictions on training data.
% algo -- The trained klogistic classifier.

% Isabelle Guyon -- April 2008 -- isabelle@clopinet.com

if algo.algorithm.verbosity>0
    disp(['training ' get_name(algo) '... '])
end

X=get_x(retDat); 
Y=get_y(retDat); 
[p,n]=size(X);

% Must convert targets to 0/1
algo.input_type=input_type(Y);
if algo.input_type==1
    Y=(Y+1)/2;
end

if strcmp(algo.optimizer, 'matlab')   
    b = glmfit(X,[Y, ones(length(Y),1)],'binomial');
    algo.b0=b(1);
    algo.W=b(2:length(b));
elseif strcmp(algo.optimizer, 'liblinear')  
    model = train(Y, sparse(X), '-s 0 -B 1 -q');
    algo.b0=model.w(end);
    algo.W=model.w(1:end-1);   
else% 'gkm' 
    algo.gkm = select(algo.selector, algo.gkm, X, Y);
end

if algo.algorithm.do_not_evaluate_training_error
    retDat=set_x(retDat,get_y(retDat)); 
else
    retDat=test(algo,retDat);
end
        








