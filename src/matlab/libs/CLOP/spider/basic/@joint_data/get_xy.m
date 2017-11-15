function [retX,retY] = get_xy(d,ind)
   
if nargin==1 
    ind=[1:size(d.Y,1)];% <--- return all we got  
end;    
    
if ~isempty(d.X)  
  retX=get_x(d,ind);
else
  retX={}; 
end

if ~isempty(d.Y)  
  retY=d.Y(ind,:);
else
  retY=[];
end