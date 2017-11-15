function rdat = rand_probe(dat, probe_num)
%rdat = rand_probe(dat, probe_num)
% Inputs:
% dat         --  A data object, including a matrix X of dim (p, n).
% probe_num  --  The number of random probe features desired.
% Returns:
% rdat        -- a matrix (p, probe_num) with the columns of which are shuffled columns of X.

% Isabelle Guyon -- December 2005 -- isabelle@clopinet.com

X=get_x(dat);
Y=get_y(dat);

% Suppress the features with zero variance /Dec 20,2005/
S=var(X);
gidx=find(S~=0);
X=X(:,gidx);

[p,n]=size(X);

block_num=floor(probe_num/n);
remain_num=probe_num-block_num*n;

% Use multiple times all probe features permuted
RX=zeros(p,probe_num);
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

rdat=data(RX, Y);