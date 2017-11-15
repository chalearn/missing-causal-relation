function dat  =  testing(algo,dat)
% if algo.testGivesProb then it means the test routine will
% output log prob of instances in each mixture

%make data only out of continuous features first
if ~strcmp(algo.FeatureType,'cont')
    dat = cont_features(algo,dat);
end


if (algo.testGivesProb)
   dat = GetLogProb(algo,dat);
   return;
end
% IMPORTANT we are assuming diagonal cov. matrices

%get the prob matrix for the instances
Prob = GetLogProb(algo,dat);

%make the overall mixture probabilities in +ve and -ve class
MixProbPos = Prob.X(:,1:algo.mixturesP);
MixProbNeg = Prob.X(:,algo.mixturesP+1:algo.mixturesP+algo.mixturesN);

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

%now see which class has max prob...
%prior of individual classes

%bring them back to absolute scale
MixProbPos = 10.^(MixProbPos);
MixProbNeg = 10.^(MixProbNeg);


%now take the sum along each row & multiply by class prob if there are more
%than one mixtures
if (algo.mixturesP > 1)
    Pos = sum(MixProbPos')*algo.PosPrior;
else
    Pos = MixProbPos*algo.PosPrior;
    Pos = Pos'
end

if (algo.mixturesN > 1)
    Neg = sum(MixProbNeg')*algo.NegPrior;
else
    Neg = MixProbNeg*algo.NegPrior;
    Neg = Neg'
end


    
%tempN = Neg > Pos;
%tempN = (Neg .* tempN) * -1;    % will have -ve prob values for -ve classification & 0 for +ve class
%tempP = Pos > Neg;              % will have +ve prob values for +ve classification & 0 for +ve class
%tempP = (Pos .* tempP); 
%yEst = tempP + tempN;
yEst = Pos - Neg;
yEst = yEst';
dat=set_x(dat,yEst); 
dat=set_name(dat,[get_name(dat) ' -> ' get_name(algo)]); 