function [retDat,algo] =  training(algo,retDat)
%[retDat,algo] =  training(algo,retDat)
% Train a Logitboost classifier.
% Inputs:
% algo -- A Logitboost classifier object.
% retDat -- A training data object.
% Returns:
% retDat -- The same data structure, but X is replaced by the class label
% predictions on training data.
% algo -- The trained Logitboost classifier.

% Isabelle Guyon -- September 2006 -- isabelle@clopinet.com

if algo.algorithm.verbosity>0
    disp(['training ' get_name(algo) '... '])
end

X=full(get_x(retDat)); % Can't deal with sparse matrices ?
Y=full(get_y(retDat)); 
algo.nboost=algo.units;

% Must convert targets to +-1 (Logitboost brings them back to 0,1
% internally in the R program)
algo.input_type=input_type(Y);
if algo.input_type==0
    Y=2*Y-1;
end

algo.lb=fevalR('LBtrain', 'x', X, 'y', Y, 'train', algo.train, ...
    'nboost', algo.nboost, 'shrink', algo.shrinkage, ...
    'depth', algo.depth, 'zmax', algo.zmax, 'graphic', algo.graphic);

if algo.algorithm.do_not_evaluate_training_error
    retDat=set_x(retDat,get_y(retDat)); 
else
    retDat=test(algo,retDat);
end
        








