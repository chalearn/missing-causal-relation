function [retDat,algo] =  training(algo,retDat)
%[retDat,algo] =  training(algo,retDat)
% Train a Random Forest classifier.
% Inputs:
% algo -- A Random Forest classifier object.
% retDat -- A training data object.
% Returns:
% retDat -- The same data structure, but X is replaced by the class label
% predictions on training data.
% algo -- The trained Random Forest classifier.

% Isabelle Guyon -- September 2005 -- isabelle@clopinet.com

if algo.algorithm.verbosity>0
    disp(['training ' get_name(algo) '... '])
end

X=full(get_x(retDat)); % Can't deal with sparse matrices 
Yt=full(get_y(retDat)); 
[p,n]=size(X); 

if length(unique(Yt))==1
    fprintf('RF::training: single class, no training\n');
    return
end

% Vector of RF parameters
ntree=algo.units; % number of trees
if isempty(algo.mtry),
    algo.mtry=round(sqrt(n)); % number of candidate feature per split
end
mtry=algo.mtry;
ntree=algo.units;

switch algo.optimizer
    case 'R'
        if algo.balance            
            npos=length(find(Yt>0));
            nneg=length(find(Yt<0));
            classwt=[1/nneg, 1/npos];
            algo.forest=fevalR('RFtrain', 'x', X, 'y', Yt, 'ntree', ntree, 'mtry', mtry, 'classwt', classwt);
        else
            algo.forest=fevalR('RFtrain', 'x', X, 'y', Yt, 'ntree', ntree, 'mtry', mtry);
        end
    case 'Weka'
        % ...
    case 'Merk'

        % Convert targets to 1...c values (<=0 values not allowed)
        algo.targets=unique(Yt);
        Y=zeros(size(Yt));
        for k=1:length(algo.targets)
            idx=find(Yt==algo.targets(k));
            Y(idx)=k;
        end

        % Vector indicating whether a variable is continuous (1) or categorical (0)
        cat = ones(1,n);
        featval=full(unique(X(:)));
        if length(featval)==2
            cat = 2*cat;
        end
        % Vector indicating the class priors
        nclass=length(algo.targets);
        if algo.balance
            K=floor(p/nclass);
            for k=1:nclass
                pp(k)=length(find(Y==algo.targets(k)));
                classwt(k)=(pp(k)+K)/(p+nclass*K);
            end
        else
            classwt = ones(1,nclass); % Uniform prior
        end

        iaddcl=0; % do not add a synthetic class
        ndsize=1; % minimum size of terminal node (make larger if too slow)
        imp=1; % assess importance of predictors
        iprox=0; % don't assess proximity among rows
        ioutlr=0; % don't assess row outliers
        iscale=0; % don't compute coord. scaling based on proximity matrix
        ipc=0; % don't compute principal coord. from cov. matrix
        inorm=0; % don't normalize
        isavef=1; % retain the forest in the output object
        mdimsc=0; % Number of scaling coordinates to be extracted. Usually 4-5 is sufficient.
        mdimpc=0;  % Number of principal components to extract. Must < m-dim.
        seed=123; % Seed for random number generation.

        in_param = [ntree,   mtry,    nclass,  iaddcl,  ndsize, ...
                    imp,     iprox,   ioutlr,  iscale,  ipc, ...
                    inorm,   isavef,  mdimsc,  mdimpc,  seed ];
        algo.param=in_param;
        % Build RF classifier
        algo.forest = RFClass(in_param, X, Y, cat, classwt);
end

%if algo.algorithm.do_not_evaluate_training_error
    retDat=set_x(retDat,get_y(retDat)); 
%else
%    retDat=test(algo,retDat);
    % this is the out of bag training preditions
    %retDat=set_x(retDat,algo.targets(algo.forest.ypredtr));
%end
        








