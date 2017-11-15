function im=show_digit(v, miss, color)
% im=show_digit(v)
% show a digit from a vector format

% Isabelle Guyon -- isabelle @ clopinet.com -- July 2003
warning off
ld=length(v);
nd=sqrt(ld);
im=255-reshape(v,nd,nd)';
num=256;
map=gray(num);
imn = inormalize(im);

if (nargin>1)
    imiss=reshape(miss,nd,nd)';
    imn(isnan(imn))=1;
end

imn = uint8(imn*(num-1));
colormap(map);
image(imn); 
if (nargin>1)
    hold on
    [x_miss y_miss] = find(imiss);
    plot(y_miss, x_miss, [color '.'],'MarkerSize', 20);
    hold off
end
warning on
