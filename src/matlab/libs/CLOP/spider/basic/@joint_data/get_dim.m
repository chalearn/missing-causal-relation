
function [l,n,k] = get_dim(dat)

%   [numEx,nInp,oDim]=get_dim(data)
%    return (in given order) the number of examples, the number of input spaces
%   the number of output dimensions
%    



  l=length(dat.index);
  n = length(dat.X);
  k=size(dat.Y,2); 
  