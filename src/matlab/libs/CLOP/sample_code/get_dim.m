function [l,n] = get_dim(dat)

if isempty(dat)
    l=0; n=0;
else
    [l, n]=size(dat.X);
end