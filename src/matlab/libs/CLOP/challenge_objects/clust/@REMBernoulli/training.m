function [retDat,algo] =  training(algo,retDat)

%first make sure we have only binary features
if ~strcmp(algo.FeatureType,'binary')
    retDat = bin_features(algo,retDat);
end

x=get_x(retDat);
y=get_y(retDat);

%----------------------------now get the +ve examples and find the mixtures
xp = find(y>0);
x  = x(xp,:);
x = sparse(x);
%x = full(x);
[algo.probP algo.priorP] = librem({'X',x},...
                                      {'iterations',algo.IterationsP},...
                                      {'mixtures',algo.mixturesP},{'gamma',algo.gamma});  
%eliminate the mixtures with priors less than a threshold value                                      
if (algo.EliminatePriors~=0)
    [algo.probP algo.priorP algo.mixturesP]= ...
                                    Eliminate(algo.probP, algo.priorP, algo.EliminatePriors); 
end                                      
%----------------------------now get the -ve examples and find the mixtures
x = get_x(retDat);
xn = find(y<0);
x  = x(xn,:);
x = sparse(x);
%x = full(x);
[algo.probN algo.priorN] = librem({'X',x},...
                                      {'iterations',algo.IterationsN},...
                                      {'mixtures',algo.mixturesN},{'gamma',algo.gamma});                                       
% eliminate if necessiry                                  
if (algo.EliminatePriors~=0)
    [algo.probN algo.priorN algo.mixturesN]= ...
                                    Eliminate(algo.probN, algo.priorN, algo.EliminatePriors); 
end                                      
                                  
                                      
%-----------------------------------------find the class probabilities also
[numEx,vDim,oDim,numCls]=get_dim(retDat);
algo.PosPrior = length(xp)/numEx;
algo.NegPrior = length(xn)/numEx;

retDat = test(algo,retDat);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%function to eliminate the priors with value less than a threshold
function [Prob Prior TotalMixtures] = Eliminate(Prob,Prior,threshold)
    x = find(Prior < threshold);
    Prior(x,:) = [];
    Prob(x,:) = [];
    TotalMixtures = length(Prior);
    %lets sort them also according to prior
    [Prior indices]=sort(Prior,'descend');
    Prob = Prob(indices,:);