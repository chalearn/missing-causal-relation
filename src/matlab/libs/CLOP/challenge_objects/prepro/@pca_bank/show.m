function [Y, map] = show(a, num, noshow)
%[Y, map] = gmat_display(a, num, noshow)
% Display matrix the filter bank in gray levels after rescaling.
% Inputs:
% a -- kernel object.
% Optional:
% num -- number of gray levels (default 256).
% noshow -- a flag. If 1, the figure is not displayed.
% Returns:
% Y -- rescaled matrix X (in uint8, to make an image).
% The largest values are shown as black.

% Isabelle Guyon -- November 2005 -- isabelle@clopinet.com

if (nargin<2|isempty(num)), num=256; end
if (nargin<3|isempty(noshow)), noshow=0; end

% Assumes that we have square images
dim1=sqrt(size(a.data.X,2));
dim2=dim1;

% Arrange the templates in a layout of submatrices
adim1=ceil(sqrt(size(a.data.X,1)));
adim2=adim1;
k=0;
M=zeros(dim1*adim1, dim2*adim2);
jmax=0;
for j=1:adim2
    jmin=jmax+1;
    jmax=jmax+dim2;
    imax=0;
    for i=1:adim1
        imin=imax+1;
        imax=imax+dim1;
        k=k+1;
        if k>size(a.data.X,1), break; end
        M(imin:imax, jmin:jmax)= reshape(a.data.X(k,:), dim2, dim1)';
    end
end

% Display

map=gray(num);
Y = inormalize(-M);
warning off
Y = uint8(Y*(num-1));
if(~noshow) 
    figure;
    colormap(map);
    image(Y); 
end
warning on

title('PCA bank');
