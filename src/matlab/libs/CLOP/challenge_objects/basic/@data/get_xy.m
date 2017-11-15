function [retX,retY] = get_xy(d,ind)
 
%   get_xy(DATA)         returns X and Y matrices of the data object
%   get_xy(DATA,INDEXES) returns X and Y matrices of the data 
%                        object for given indexes
  
if (nargin==1)|isempty(ind),
    ind=[1:size(d.X,1)]; % <---- return all we got 
end;
    
if ~isempty(d.X)  
  retX=d.X(ind,:);
else
  retX=[]; 
end

if ~isempty(d.Y)  
  retY=d.Y(ind,:);
else
  retY=[];
end