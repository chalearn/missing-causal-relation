function f=fcheck(fn)
%f=fcheck(fn)
% Check that the file exists

f=(exist(fn) == 2);

