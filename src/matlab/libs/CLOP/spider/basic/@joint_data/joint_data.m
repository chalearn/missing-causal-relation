
function data = joint_data(name,X,Y) 
%========================================================================================================  
% Joint_data object
%========================================================================================================
% Stores multiple input data and output data into two components X (input) and Y (output).
%
% An object is created with:
%   data('name',X,Y); 
%       or 
%   data(X,Y); (no name)
%       or 
%   data(X); (in case there's no output, e.g clustering)
%
%
% Public attributes:
%  X          -- cell array of data or data_struc objects containing
%                   several input domains
%  Y          -- output matrix       
%  index      -- original parent indices of examples 
%  findex     -- original parent indices of features (ignored, but kept for compatibility)
%
% Public methods:
%  d=get(data,index,featInd)             -- return data,index only (ind)examples,(find)features 
%  x=get_x(data,index,fInd)              -- return x,index only (ind)examples,(find)features 
%  y=get_y(data,index,fInd)              -- return y,index only (ind)examples,(find)features 
%  d=set_x(data,X,indes,featInd)         -- set inputs indexed by (ind)examples,(find)features
%  d=set_y(data,Y,index,featInd)         -- set outputs indxed by (ind)examples,(find)features
%  [indes,featInd]=get_index(d)          -- returns example and feature indices
%  [numEx,numInputDom,oDim]=get_dim(d)   -- returns number of  examples,number of input domains,output dimensions
%
% Example: 
% X = {}, for i = 1:10, X{i} = rand(round(10*rand)), end
% dj = joint_data({data(rand(10)),data_struct(X)},sign(rand(10,1)-0.5))
% get(dj,[1:3])
%

  if nargin==0
     name='joint_data (empty)';
     data.X={}; data.Y=[];
     data.index=[]; data.findex={};
     %data = class(data,'data');
   else 
     data.X={}; data.Y=[];
     if nargin>=2 data.X=X; end
     if nargin>=3 data.Y=Y; end;
     if ~isa(name,'char') 
       data.Y=data.X;
       data.X=name;
       name=['joint_data'];
     end
     
     X=data.X;
     if isa(X,'cell')
       data.index = [1:get_dim(X{1})];
       for i = 1:length(X)
        tmp = X{i};
        data.findex{i} = 1:length(X{i}.findex);
       end
     else
        disp('Error: Input has to be a cell array');    
     end

  end
  p=algorithm(name); p.is_data=1;
  data= class(data,'joint_data',p);
    
  