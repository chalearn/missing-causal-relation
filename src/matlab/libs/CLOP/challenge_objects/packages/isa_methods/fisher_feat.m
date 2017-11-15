function [idxs,crit]=fisher_feat(X_train, Y_train, feat_num, logfile)
%[idxs,crit]=fisher_feat(X_train, Y_train, feat_num, logfile)
% Feature ranking using the Fisher criterion.
% Inputs:
% X_train --     Training data matrix, n examples x p patterns.
% Y_train --     Target vector of n x 1.
% feat_num --    Desired number of features.
% logfile  --    Log file handle.
% Returns:
% idxs   --      Sorted feature indices (best first).
% crit  --       Ranking criterion.

% Isabelle Guyon -- December 2005 -- isabelle@clopinet.com

%The Fisher criterion is the ratio of the between class variance and 
%the "pooled" within class variance (the average of the class variances, 
%weighted by the class proportions p_i/p, where p_i is the number of examples 
%of class i and p the total number of examples). 
%To get the correct F statistic, the denominator should in fact be the
%variance of the mean (differs by the number of examples per class). 
%Also, one should take into account the degrees of fresdom
%to get unbiased estimates of the variance. 
%The anovan Matlab function computes the correct statistic but is very
%slow.
%In Matlab, the command var computes an unbiased estimate. 
%An auxiliary module "runvar" computes the variance with a running average 
%and avoids memory problems for large matrices.
%To estimate the pvalue, you can use 1-fcdf(F,v1,v2), where F is the Fisher
%criterion and v1 and v2 the degrees of freedom at the numerator and denominator:
%v1=c-1    (number of classes minus one -- because you used 1 d.f. to compute 
%           the mean of all classes)
%v2=p-c    (number of examples minus number of classes -- because you used 
%           c.d.f. to estimate all the class means)
%Note that the fisher_feat function returns sorted indices (idxs) and 
%sorted F values (crit). 

[pp,nn]=size(X_train);
if nargin<3 , feat_num=nn; end
if nargin<4 | isempty(logfile), logfile=2; end

if(length(find(Y_train==-1))~=0)
    Y=(Y_train+1)/2; %0/1 values.
else
    Y=Y_train;
end

[patt_num, feat_num]=size(X_train);
labels=unique(Y);
cl_num=length(labels);

% Find patterns of each class
cl_idx=cell(cl_num,1);
for k=1:cl_num
    cl_idx{k}=find(Y==labels(k));
end

% Compute class centroids:
mu_val=zeros(cl_num, feat_num);
for k=1:cl_num
    mu_val(k, :)=mean(X_train(cl_idx{k},:));
end

% Compute the pooled within class variance
var_val=zeros(cl_num, feat_num);
patt_per_class=zeros(cl_num,1);
for k=1:cl_num
    var_val(k, :)=runvar(X_train(cl_idx{k},:));
    patt_per_class(k)=length(cl_idx{k});
end

Unbiased_within_var=sum(var_val.*patt_per_class(:, ones(1,feat_num)))/(patt_num-cl_num);
Unbiased_within_var(find(Unbiased_within_var==0))=eps;

% Compute the between class variance
%Unbiased_between_var=var(mu_val);
% Here there is a trick: we reweight by the number of pattern per class
% This will account for the case of unbalanced classes. 
% In a way, instead of dividing the denominator by the number of examples
% per class, we multiply the numerator by the number of examples per class.

%mu_overall=mean(mu_val);
%v_bet=(mu_val-mu_overall(ones(cl_num,1),:)).^2;
%Unbiased_between_var=sum(v_bet.*patt_per_class(:, ones(1,feat_num)))/(cl_num-1);

% Case of imbalanced classes
inv_ppc=mean(1./patt_per_class);
Unbiased_between_var=var(mu_val)/inv_ppc;

% Compute the Fisher criterion
%fprintf('X1: %g\n', Unbiased_between_var);
%fprintf('Error: %g\n', Unbiased_within_var);
f_crit=Unbiased_between_var./Unbiased_within_var;
%fprintf('F: %g\n', f_crit);
%fprintf('pval: %g\n', 1-fcdf(f_crit,(cl_num-1), (patt_num-cl_num)));

[dd, idxs]=sort(-f_crit);
crit=f_crit(idxs);

if ~isempty(feat_num)
    feat_num=min(feat_num,length(idxs));
    idxs=idxs(1:feat_num);
    crit=crit(1:feat_num);
end

return
  
            