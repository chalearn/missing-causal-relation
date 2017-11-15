function [nearest_hits, nearest_misses]=find_neighbors(C, Y, num)
%[nearest_hits, nearest_misses]=find_neighbors(C, Y, num)
% Implement relief for each individual pattern
% C= correlation or kernel matrix
% num=number of neighbors

% Isabelle Guyon -- isabelle@clopinet.com -- June 2004

p=length(Y);
pidx=find(Y==1)';
nidx=find(Y==-1)';

for k=1:p, C(k,k)=0; end
p=size(C,1);
nearest_hits=zeros(p,num);
nearest_misses=zeros(p,num);
for i=1:p
    if Y(i)==1;
        [z,nh]=sort(-C(i, pidx));
        nearest_hits(i,:)=pidx(nh(1:num));
        [z,nm]=sort(-C(i, nidx));
        nearest_misses(i,:)=nidx(nm(1:num));
    else
        [z,nh]=sort(-C(i, nidx));
        nearest_hits(i,:)=nidx(nh(1:num));
        [z,nm]=sort(-C(i, pidx));
        nearest_misses(i,:)=pidx(nm(1:num));
    end
end