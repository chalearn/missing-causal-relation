function im=show_digit(v)
% im=show_digit(v)
% show a digit from a vector format

% Isabelle Guyon -- isabelle @ clopinet.com -- July 2003
warning off
ld=length(v);
nd=sqrt(ld);
im=255-reshape(v,nd,nd)';
im=im(nd:-1:1,:);
num=256;
map=gray(num);
imn = inormalize(im);
imn = uint8(imn*(num-1));
colormap(map);
image(imn); 
warning on
