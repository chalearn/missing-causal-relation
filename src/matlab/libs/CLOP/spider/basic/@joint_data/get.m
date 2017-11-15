function [dat] = get(dt,ind,fInd) 

%   data=get(data)                      returns the data of the data object 
%   data=get(data,examIndex,featIndex)  returns the data of the data object 
%                                       for given indexes   
empty=0; 
if nargin>1 
    empty=isempty(ind);  
end;

if (nargin==1 | empty) 
    ind=[1:size(dt.Y,1)];  %<--- return all examples 
end;  

inp = dt.X;

if nargin<3 
    fInd = {};
    for i = 1:length(inp)
        tmp = inp{i};
        fInd{i}= tmp.findex; %<--- return all features
    end
end;          

y=[]; 
if ~isempty(dt.Y) 
    y=dt.Y(ind,:); 
end;
    
x={}; 
if ~isempty(dt.X) 
    for i = 1:length(inp)
        x{i}= get(inp{i},ind,fInd{i}); 
    end
end;
  
dat  = joint_data(dt.algorithm.name,x,y); 
dat.index = dt.index(ind);


tmp = {};
find_inp = dt.findex;
for i = 1:length(inp)
    tmp2 = find_inp{i};
    tmp{i} = tmp2(fInd{i});
end
dat.findex = tmp;



