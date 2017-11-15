function [retDat,algo] =  training(algo,retDat)

%make data only out of continuous features first
if ~strcmp(algo.FeatureType,'cont')
    retDat = cont_features(algo,retDat);
end

x=get_x(retDat);
y=get_y(retDat);

%----------------------------now get the +ve examples and find the mixtures
xp = find(y>0);
x  = x(xp,:);
x = full(x);
[algo.meanP algo.covP algo.priorP] = libemGauss({'X',x},...
                                      {'iterations',algo.IterationsP},...
                                      {'mixtures',algo.mixturesP});  

                                  
%----------------------------now get the -ve examples and find the mixtures
x = get_x(retDat);
xn = find(y<0);
x  = x(xn,:);
x = full(x);
[algo.meanN algo.covN algo.priorN] = libemGauss({'X',x},...
                                      {'iterations',algo.IterationsN},...
                                      {'mixtures',algo.mixturesN});                                    
                                      
%-----------------------------------------find the class probabilities also
[numEx,vDim,oDim,numCls]=get_dim(retDat);
algo.PosPrior = length(xp)/numEx;
algo.NegPrior = length(xn)/numEx;

retDat = test(algo,retDat);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
