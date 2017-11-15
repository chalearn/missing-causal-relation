
function [retX] = get_x(D,ind,fInd)
%   get_x(DATA)          returns X matrix of the data object
%   get_x(DATA,INDEXES)  returns X matrix of the data object 
%                        for given indexes
  
X=[]; 

p=length(D.child);
for i=1:p
    X=[X; get_x(D.child{i})];
end

if (nargin==1)|isempty(ind),
    ind=[1:size(X,1)]; % <---- return all we got 
end;    
if nargin < 3 | isempty(fInd),
    fInd = [1:size(X,2)];
end;
if ~isempty(X)  
  retX=X(ind,fInd);
else
  retX=[]; 
end