
function [res] = concatenate(tres,res,trn,tst)
   
%   function [dat] = concatenate(trnRes,tstRes,train,test)
%   
%   Returns unified data (e.g with train and test results)
%   with trnRes in specified indexes train and tstRes in 
%   indexes test.
  
  [l1,n1,k1]=get_dim(res);
  [l2,n2,k2]=get_dim(tres);
  l=l1+l2; 
  
  if nargin<3, trn=1:l2; tst=l2+[1:l1]; end
  
  X=zeros(l,max(n1, n2)); Y=zeros(l,max(size(res.Y,2), size(tres.Y,2)));
  if size(X,2)>0 
   if ~isempty(trn) X(trn,:)=get_x(tres); end; 
   if ~isempty(tst) X(tst,:)=get_x(res); end;
  end
  if ~isempty(trn) Y(trn,:)=get_y(tres);  end;
  if ~isempty(tst) Y(tst,:)=get_y(res); end;
  
  
  res=set_x(res,X);        %% store results in data object 
  res=set_y(res,Y);        %% see help set_x for additional information
  
