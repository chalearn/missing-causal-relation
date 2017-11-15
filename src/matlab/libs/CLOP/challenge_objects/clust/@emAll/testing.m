function dat  =  testing(algo,dat)
% if algo.testGivesProb then it means the test routine will
% output log prob of instances in each mixture



if (algo.testGivesProb)
   probBernoulli = GetLogProb(algo.bernoulli,dat);
   probBernoulli = train(normalize,probBernoulli);
   probGauss = GetLogProb(algo.gauss,dat);    
   probGauss = train(normalize,probGauss);
   Prob = [probBernoulli.X probGauss.X];
   dat=set_x(dat,Prob); 
   dat=set_name(dat,[get_name(dat) ' -> ' get_name(algo)]); 
   return;
end

bern = test(algo.bernoulli,dat);
gauss = test (algo.gauss,dat);

BernErr = balanced_errate(bern.X,bern.Y);
GaussErr = balanced_errate(gauss.X,gauss.Y);

%fprintf('\n Errors of individual models: Bernoulli: %f  Gauss: %f',BernErr*100.0, GaussErr*100.0)
%combine the two models
%two methods are possible comment one out 
%take the average
yEst = (bern.X+gauss.X)/2;
%take the maximum
yEst = max([bern.X gauss.X],[],2);

dat=set_x(dat,yEst); 
dat=set_name(dat,[get_name(dat) ' -> ' get_name(algo)]); 


%{
%count of +ve and -ve mixtures
BerMixP = algo.bernoulli.mixturesP;
BerMixN = algo.bernoulli.mixturesN;
GaussMixP = algo.gauss.mixturesP;
GaussMixN = algo.gauss.mixturesN;

%making a prob matrix for +Ve class and one for -ve class
MixProbPos = probBernoulli.X(:,1:BerMixP);
MixProbPos = [MixProbPos probGauss.X(:,1:GaussMixP)];
MixProbNeg = probBernoulli.X(:,BerMixP+1:BerMixN+BerMixP);
MixProbNeg = [MixProbNeg probGauss.X(:,GaussMixP+1:GaussMixN+GaussMixP)];


%prior of individual mixtures
priorMixP = [algo.bernoulli.priorP algo.gauss.priorP];
priorMixN = [algo.bernoulli.priorN algo.gauss.priorN];

%log scale of priors of each mixture
PriorP = log10(algo.priorP);
PriorN = log10(algo.priorN);

%now add the priors
for i=1:1:algo.mixturesP
    MixProbPos(:,i) = MixProbPos(:,i)+PriorP(i);
end

for i=1:1:algo.mixturesN
    MixProbNeg(:,i) = MixProbNeg(:,i)+PriorN(i);
end



%bring them back to absolute scale
MixProbPos = 10.^(MixProbPos);
MixProbNeg = 10.^(MixProbNeg);
%now take the sum along each row & multiply by class prob
Pos = sum(MixProbPos')*PosPrior;
Neg = sum(MixProbNeg')*NegPrior;

tempN = Neg > Pos;
tempN = (Neg .* tempN) * -1;    % will have -ve prob values for -ve classification & 0 for +ve class
tempP = Pos > Neg;              % will have +ve prob values for +ve classification & 0 for +ve class
tempP = (Pos .* tempP); 
yEst = tempP + tempN;
%yEst = Pos - Neg;
yEst = yEst';
dat=set_x(dat,yEst); 
dat=set_name(dat,[get_name(dat) ' -> ' get_name(algo)]); 

%}