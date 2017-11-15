function [methodir, dataset, method] = identify(dirname, test_only, Flist)
% [methodir, dataset, method] = identify(dirname, test_only, Flist)
% Identify the methods and datasets 
% If test_only file is on, refuse dir without test results.

methodlist=dir(dirname);
ll=length(methodlist)-2;
methodir=cell(ll,1);
method=cell(ll,1);
for i=1:ll
    methodir{i}=methodlist(i+2).name;
end
if nargin>2 
    methodir=intersect(methodir,Flist);
    ll=length(methodir);
end
for i=1:ll
    mid=[];%label_read([dirname '\' methodir{i} '\method']);
    gid=[];%label_read([dirname '\' methodir{i} '\name']);
    if ~isempty(gid) & ~isempty(mid), 
        m1=mid{1};
        m1(m1==' ')='_';
        m2=gid{1};
        m2(m2==' ')='_';
        method{i}=[methodir{i} ' ' m1 ' ' m2]; 
    else
        method{i}=methodir{i};
    end
end
if test_only
    idx_good=[];
	for i=1:ll
        istest=dir([dirname '\' methodir{i} '\*_test.resu']);
        if length(istest)>=1, idx_good=[idx_good, i]; end
	end
	methodir=methodir(idx_good); 
    method=method(idx_good); 
    ll=length(methodir);
end
dataset={};
for i=1:ll
    resulist=dir([dirname '\' methodir{i} '\*.resu']);
    pp=length(resulist);
    ds=cell(pp,1);
    for j=1:pp
        name=resulist(j).name;
        s=findstr('_', name);
        if ~isempty(s), 
            ds{j}=name(1:s(1)-1); 
        else
            ds{j}='';
        end
    end
    dataset=[dataset; ds];
end
dataset=unique(dataset);
dataset=setdiff(dataset, {''});

return
