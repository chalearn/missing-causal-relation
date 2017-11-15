function [retDat,algo] =  training(algo,retDat)

algo.bernoulli.testGivesProb = 0;
algo.gauss.testGivesProb = 0;

temp = retDat;
[binaryData algo.bernoulli] = train(algo.bernoulli,temp);
temp = retDat;
[contData algo.gauss] = train(algo.gauss,temp);

retDat = test(algo,retDat);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
