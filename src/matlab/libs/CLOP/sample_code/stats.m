function [vartype, sparsity, tartype, valnum, balance, n, p]=stats(dat, fp)
% [vartype, sparsity, tartype, valnum, balance, n, p]=stats(dat, fp)
% dat is a data structure
% fp is a file descriptor
% Print data statistics

% Isabelle Guyon -- isabelle@clopinet.com -- February 2006

if nargin<2, fp=2; end


NOTARGET=0;

% Collect statistics
X=dat.X;
Y=dat.Y;
[p,n]=size(X);
pp=length(Y);
if p~=pp, NOTARGET=1; end
% sparsity
sparsity=1-(nnz(X)/prod(size(X)));
% variable type
range=max(X)-min(X);
binary=all(range<=1);
mixed=any(range==1);
numb=length(find(range==1))+1;
probably_continuous=(length(find(range>1))/numb > 50);
if binary, 
    vartype='binary';
elseif mixed & ~probably_continuous
    vartype='mixed';
else
    vartype='cont.';
end

if NOTARGET
    tartype='unknown';
    balance='NA   ';
    valnum=0;
else
    % target type
    UY=unique(Y);
    if length(UY)<2, 
        tartype='unary';
    elseif length(UY)==2,
        tartype='binary';
    elseif all(round(UY)==UY)
        tartype='multi.';
    else
        tartype='cont.';
    end
    valnum=length(UY);
    % Balance
    bal0=p/valnum; % ideal balance
    if ~strcmp(tartype, 'continuous') & ~isempty(UY)
        for k=1:length(UY)
            nelem(k)=length(find(Y==UY(k)));
        end
        balance=num2str(round(1000*min(nelem)/bal0)/1000);
    else
        balance='NA   ';
    end
end
% Results
if fp>=0
    fprintf(fp, '\nX Type = %s \nSparsity = %5.3f \nY Type = %s (ValNum=%d) \nBalance = %s \nFeatNum = %d \nPatNum = %d  \nPat/Feat = %5.3f\n', ...
    vartype, sparsity, tartype, valnum, balance, n, p, p/n); 
end

return