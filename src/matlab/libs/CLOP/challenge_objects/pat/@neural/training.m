function [retDat,algo] =  training(algo,retDat)
%[retDat,algo] =  training(algo,retDat)
% Train a Neural Network classifier.
% Inputs:
% algo -- A Neural Network classifier object.
% retDat -- A training data object.
% Returns:
% retDat -- The same data structure, but X is replaced by the class label
% predictions on training data.
% algo -- The trained Neural Network classifier.

% Isabelle Guyon -- September 2005 -- isabelle@clopinet.com

if algo.algorithm.verbosity>0
    disp(['training ' get_name(algo) '... '])
end

X=get_x(retDat); 
Y=get_y(retDat); 
[p,n]=size(X);
[p,c]=size(Y);

% Call the network constructor
algo.net=mlp(n, algo.units, c, 'linear', algo.shrinkage);

sqrt_iter=round(sqrt(algo.maxiter));
% Set up vector of options for the optimiser.
options = zeros(1,18);
if algo.balance
    options(1) = -1;			    % This provides display of error values.
    options(14) = sqrt_iter;		% Number of training cycles. 
else
    options(1) = 1;			        
    options(14) = algo.maxiter;
end

if ~algo.balance
    % Regular batch learning
    [algo.net, algo.options] = netopt(algo.net, options, X, Y, 'scg');
else
    % Resampling to balance classes (works for 2 classes in this implementation)
    pidx{1}=find(Y>0);
    pidx{2}=find(Y<0);
    pp(1)=length(pidx{1});
    pp(2)=length(pidx{2});
    [pmax, maxcl]=max(pp); % class to resample
    [pmin, mincl]=min(pp); % the other class
    iperm=randperm(pmax);
    iselect=iperm(1:pmin);
    pmaxcl=pidx{maxcl};
    pmincl=pidx{mincl};
    Xtr=[X(pmincl,:); X(pmaxcl(iselect),:) ];
    Ytr=[Y(pmincl); Y(pmaxcl(iselect))];

    for k=1:sqrt_iter
        algo.itnum=algo.itnum+sqrt_iter;
        fprintf(2, 'Cycle %5d ', algo.itnum); 
        % randomly permute, just to make sure
        rp=randperm(size(Xtr,1));
        % train
        [algo.net, algo.options] = netopt(algo.net, options, Xtr(rp,:), Ytr(rp), 'scg');
        % find the errors of classification
        Yhat=mlpfwd(algo.net, X);
        BER=balanced_errate(Yhat,Y);
        fprintf(2, 'BER %5.2f%%\n', 100*BER);
        % Sample the data at random to get the same number of examples
        % in each class; keep the samples that failed classification.
        is_err=(Yhat~=Y);
        keep_it=find(is_err(pmaxcl));
        others=find(~is_err(pmaxcl));
        rp=randperm(length(others));
        iselect=[keep_it; others(rp(1:pmin-length(keep_it)))];
        Xtr=[X(pmincl,:); X(pmaxcl(iselect),:) ];
        Ytr=[Y(pmincl); Y(pmaxcl(iselect))];
    end   
end

if algo.algorithm.do_not_evaluate_training_error
    retDat=set_x(retDat,get_y(retDat)); 
else
    retDat=test(algo,retDat);
end