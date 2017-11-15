function [idxs,crit]=golub_feat(X, Y, feat_num, logfile, balance)
%[idxs,crit]=golub_feat(X, Y, feat_num, logfile, balance)
% Feature ranking using the Golub criterion.
% Inputs:
% X --     Training data matrix, n examples x p patterns.
% Y --     Target vector of n x 1.
% feat_num --    Desired number of features.
% logfile  --    Log file handle.
% balance --  If 1, balance the number of positive and negative features. 
% Do not take the abs of the criterion. Otherwise take abs value.
% In the first case informative features are top and bottom ranking.
% In the last case they are top ranking.
% Returns:
% idxs   --      Sorted feature indices (best first).
% crit  --       Ranking criterion.

[~,nn]=size(X);
if nargin<3 || isempty(feat_num), feat_num=nn; end
if nargin<4 || isempty(logfile), logfile=2; end
if nargin<5 balance=0; end

Posidx=find(Y>0);
Negidx=find(Y<=0);
Mu1=mean(X(Posidx,:));
Mu2=mean(X(Negidx,:));
Sigma1=std(X(Posidx,:),1); % Biased version of it
Sigma2=std(X(Negidx,:),1);
Sigma=0.5*(Sigma1+Sigma2);
Sigma(Sigma==0)=eps;
if balance
    g_crit=(Mu1-Mu2)./(Sigma);
else
    g_crit=abs(Mu1-Mu2)./(Sigma);
end
[~,idxs]=sort(-g_crit);
crit=g_crit(idxs);

if ~isempty(feat_num)
    feat_max=length(idxs);
    feat_num=min(feat_num,feat_max);
    if balance
        fn=ceil(feat_num/2);
        if fn==feat_num/2
            idx=[1:fn,feat_max-fn+1:feat_max];
        else
            idx=[1:fn,feat_max-fn+2:feat_max];
        end
    else
       idx=1:feat_num;
    end
    crit=crit(idx);
    idxs=idxs(idx);
end

return
  
            