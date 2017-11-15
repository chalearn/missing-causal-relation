function [retDat,algo] =  training(algo,retDat)
%[retDat,algo] =  training(algo,retDat)
% Train a Bias postprocessor.
% Inputs:
% algo -- A Bias classifier object.
% retDat -- A training data object.
% Returns:
% retDat -- The same data structure, but X is replaced by the class label
% predictions on training data.
% algo -- The "trained" bias.

% Isabelle Guyon -- February 2006 -- isabelle@clopinet.com

if algo.algorithm.verbosity>0
    disp(['training ' get_name(algo) '... '])
end

X=get_x(retDat); 
Y=get_y(retDat); 
[p,n]=size(X);

%% If the target values are not binary, assume the regression case and 
%% just compute the average difference to the target
if length(unique(Y))>2
    algo.b0=mean(retDat.Y) - mean(retDat.X);
else

    %% Option 4 -- First trivial method: compute the fraction of positive examples
    %% in the training set. We will then compute b0 at test time
    %% to match this fraction in the test data
    %% This method is transductive (uses statistics one the test data).

    ppos=length(find(Y>0));
    algo.fpos=ppos/p;

    %% Other options -- Second method: really re-estimate the bias from training data.
    %% This method is not "transductive", i.e. does not assume
    %% that all the test data will be available simultaneously at test time.
    if algo.option~=4
        algo.b0 = bias_optimize(X, Y, algo.option);
    end
end

if algo.algorithm.do_not_evaluate_training_error
    retDat=set_x(retDat,get_y(retDat)); 
else
    retDat=test(algo,retDat);
end