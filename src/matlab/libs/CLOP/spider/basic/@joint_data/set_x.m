function [retDat] = set_x(dat,inp,ind,fInd)

inplen = length(inp);

if inplen ~= length(dat.X),  
    if ~iscell(inp)
        retDat = data(get_name(dat),inp,dat.Y)
    else
        retDat = joint_data(get_name(dat),inp,dat.Y);    
    end
    return, 
end

if nargin==2 | (isempty(ind)&isempty(fInd)),
    
    length_matches = [];
    for i = 1:length(inp)
        length_matches = [length_matches (size(inp{i},1)==length(dat.index))];
    end
    
    if ~ (sum(length_matches) == length(inp))
        sz = size(inp{1},1);
        if iscell(inp{1})
            sz = length(inp{1});
        end
        dat.index  = [1:sz];
    end
end    
 
Xtmp = dat.X;
if nargin == 2 | (isempty(ind)&isempty(fInd)),
    for i = 1:inplen
        Xtmp{i}= set_x(Xtmp{i},inp{i});
    end
else
    for i = 1:inplen
        Xtmp{i}= set_x(Xtmp{i},inp{i},ind,fInd);
    end
end
dat.X=Xtmp;

retDat=dat;
