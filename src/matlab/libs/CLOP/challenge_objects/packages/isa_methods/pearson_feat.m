function [idxs,crit]=pearson_feat(X, Y, feat_num, logfile, nosort)
%[idxs,crit]=pearson_feat(X, Y, feat_num, logfile, nosort)
% Feature ranking using the Pearson correlation coefficient criterion.
% Inputs:
% X --     Training data matrix, n examples x p patterns.
% Y --     Target vector of n x 1.
% feat_num --    Desired number of features.
% logfile  --    Log file handle.
% nosort -- Do not sort the results.
% Returns:
% idxs   --      Sorted feature indices (best first).
% crit  --       Ranking criterion.

[pp,nn]=size(X);
if nargin<3 , feat_num=nn; end
if nargin<4 | isempty(logfile), logfile=2; end
if nargin<5, nosort=0; end

% Subtract the means
MX=mean(X);
for k=1:size(X,1)
    X(k,:)=X(k,:)-MX;
end
Y=Y-mean(Y);

% Compute the standard deviations
VX=sqrt(mean(X.^2));
VY=sqrt(mean(Y.^2));
VX(find(VX==0))=1;
VY(find(VX==0))=1;

% Compute the covariances
CXY=zeros(size(X));
for k=1:size(CXY,1)
    CXY(k,:)=X(k,:).*Y(k,(ones(size(X,2),1)));
end
VXY=abs(mean(CXY));

% Normalize
p_crit=(VXY./VX)./VY;

if ~nosort
    [ss,idxs]=sort(-p_crit);
    crit=p_crit(idxs);
else
    idxs=1:length(p_crit);
    crit=p_crit;
end

if ~isempty(feat_num)
    feat_num=min(feat_num,length(idxs));
    idxs=idxs(1:feat_num);
    crit=crit(1:feat_num);
end

return
  
            