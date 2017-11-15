function [retX] = get_x(dat,ind,fInd)
%   get_x(DATA)          returns X matrices of the data object
%   get_x(DATA,INDEXES)  returns X matrices of the data object 
%                        for given indexes
  
inplen = length(dat.X);
inp = dat.X;

if (nargin==1)|isempty(ind),
        ind=[1:get_dim(inp{1})]; % <---- return all we got 
 end;    


 
if nargin < 3 | isempty(fInd),
    fInd = {};
    for i = 1:inplen
        tmp = inp{i};
        fInd{i} = tmp.findex;
    end
end;

if ~iscell(fInd)
    allfind = fInd;
    fInd = {};
    for i = 1:inplen
        fInd{i} = allfind;
    end
end


if ~isempty(dat.X)  
  retX = {};
  for i = 1:inplen
      tmp = inp{i};
      retX{i}=get_x(inp{i},ind,fInd{i});
  end
  
else
  retX = {}; 
end
