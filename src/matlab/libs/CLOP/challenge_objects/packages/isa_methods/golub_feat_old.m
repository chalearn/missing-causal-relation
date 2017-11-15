function [idxs,crit]=golub_feat(X, Y, feat_num, logfile)
%[idxs,crit]=golub_feat(X, Y, feat_num, logfile)
% Feature ranking using the Golub criterion.
% Inputs:
% X --     Training data matrix, n examples x p patterns.
% Y --     Target vector of n x 1.
% feat_num --    Desired number of features.
% logfile  --    Log file handle.
% Returns:
% idxs   --      Sorted feature indices (best first).
% crit  --       Ranking criterion.

[pp,nn]=size(X);
if nargin<3 , feat_num=nn; end
if nargin<4 | isempty(logfile), logfile=2; end

Posidx=find(Y>0);
Negidx=find(Y<0);
Mu1=mean(X(Posidx,:));
Mu2=mean(X(Negidx,:));
Sigma1=std(X(Posidx,:),1); % Biased version of it
Sigma2=std(X(Negidx,:),1);
Sigma=0.5*(Sigma1+Sigma2);
Sigma(find(Sigma==0))=eps;
g_crit=abs(Mu1-Mu2)./(Sigma);
[ss,idxs]=sort(-g_crit);
crit=g_crit(idxs);

if ~isempty(feat_num)
    feat_num=min(feat_num,length(idxs));
    idxs=idxs(1:feat_num);
    crit=crit(1:feat_num);
end

return
  
            