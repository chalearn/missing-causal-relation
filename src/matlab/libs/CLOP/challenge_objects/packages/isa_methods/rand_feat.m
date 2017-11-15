function RX = rand_feat(X, feat_num)
%RX = rand_feat(X, feat_num)
% Inputs:
% X         --  A matrix with n features in columns and p patterns in lines.
% feat_num  --  The number of random features desired.
% Returns:
% RX        -- a matrix (p, feat_num) with the columns of which are shuffled columns of X.

% Isabelle Guyon -- October 2002 -- isabelle@clopinet.com

[p,n]=size(X);

block_num=floor(feat_num/n);
remain_num=feat_num-block_num*n;

% Use multiple times all features permuted
if issparse(X)
    RX=sparse(p,feat_num);
else
    RX=zeros(p,feat_num);
end
for k=0:block_num-1
   for i=1:n
      idx=randperm(p);
      RX(:,i+k*n)=X(idx,i);
   end
end
% Complete the remaining with a random selection
fidx=randperm(n);
for i=1:remain_num
   idx=randperm(p);
   RX(:,i+block_num*n)=X(idx,fidx(i));
end