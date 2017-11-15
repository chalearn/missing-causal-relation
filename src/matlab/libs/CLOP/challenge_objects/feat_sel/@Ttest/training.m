function [dat, alg] =  training(alg,dat)
%[dat, alg] =  training(alg,dat)
% Compute the T statistic
% and rank the features accordingly.
% Returns the training data matrix dat restricted to the
% selected features (i.e. feat_num<=feat_max and w>w_min.

% Isabelle Guyon -- isabelle@clopinet.com -- December 2005
  
if alg.algorithm.verbosity>0
    disp(['training ' get_name(alg) '... '])
end
 
[p,n]=get_dim(dat);

X=get_x(dat);
Y=get_y(dat);

Posidx=find(Y>0);
Negidx=find(Y<0);
Mu1=mean(X(Posidx,:));
Mu2=mean(X(Negidx,:));
n1=length(Posidx);
n2=length(Negidx);

if p*n>1e6
    Var1=(n1/(n1-1))*runvar(X(Posidx,:)); 
    Var2=(n2/(n2-1))*runvar(X(Negidx,:));
else
    Var1=var(X(Posidx,:)); 
    Var2=var(X(Negidx,:));
end

% Two different ways of computing the standard error
% depending on whether the classes have the same variance or not
if alg.eqvar
    Dfree=n1+n2-2;
    Spooled=sqrt(((n1-1)*Var1 + (n2-1)*Var2) / Dfree);
    Stderr=Spooled * sqrt(1/n1 + 1/n2);
else
    Var1_ = Var1/n1;
    Var2_ = Var2/n2;
    Dfree = (Var1_ + Var2_) .^2 ./ (Var1_.^2/(n1-1) + Var2_.^2/(n2-1));
    Stderr = sqrt(Var1_+ Var2_);
end

% The t statistic
Stderr(find(Stderr==0))=1;
Tstat=abs(Mu1-Mu2)./Stderr; % We take the absolute value because it does no matter which site is largest

alg.W=Tstat;
[ss,alg.fidx]=sort(-Tstat);
alg.pval = 2*tcdf(-Tstat,Dfree); % One tailed test; The maximum pvalue will be 0.5
                                 % Multiply by 2 to get pval=1 for a zero weight
sorted_fdr=alg.pval(alg.fidx).*(n./[1:n]);
alg.fdr(alg.fidx) = sorted_fdr;
  
if ~alg.algorithm.do_not_evaluate_training_error
    dat=test(alg, dat);
end

  

  

  
  
