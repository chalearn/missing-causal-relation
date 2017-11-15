function [l,n,k,k2] = get_dim(dat)
  
%   [numEx,vDim,oDim,numCls]=get_dim(data)
%    return (in given order) the number of examples, the dimension of vectors
%    the number of output dimensions and the number of classes.

[l, n]=size(dat.data.X);
k=0;
k2=0;
