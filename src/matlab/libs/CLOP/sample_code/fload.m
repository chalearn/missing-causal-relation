function X=fload(fn)
%X=fload(fn)
% Load after check

if fcheck(fn)
    X=load(fn);
else
    X=[];
end
% Make vectors column vectors:
[p,n]=size(X);
if p==1, X=X'; end

