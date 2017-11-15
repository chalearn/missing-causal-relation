
function [retY] = get_y(D,ind,fInd)
%   get_y(DATA)          returns X matrix of the data object
%   get_y(DATA,INDEXES)  returns X matrix of the data object 
%                        for given indexes
  
Y=[]; 

p=length(D.child);
for i=1:p
    Y=[Y; get_y(D.child{i})];
end

if (nargin==1)|isempty(ind),
    ind=[1:size(Y,1)]; % <---- return all we got 
end;    
if nargin < 3 | isempty(fInd),
    fInd = [1:size(Y,2)];
end;
if ~isempty(Y)  
  retY=Y(ind,fInd);
else
  retY=[]; 
end