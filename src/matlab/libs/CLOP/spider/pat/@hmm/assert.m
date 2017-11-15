function [] = assert(alg,condition,message)
% assert(condition,message)
%
% stops matlab with error message if assert condition is not true

if (nargin<3) message = ''; end
if(~condition) 
  ddd = dbstack;
  if(length(ddd)>1) dname=ddd(2).name; else dname='command line'; end
  fprintf(1,'!!! assert failure (%s)!!!\n    in function %s\n',...
      message,dname); 
end

