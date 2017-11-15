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

% Arrange the templates in a layout of submatrices
k=0;
M=zeros(a.dim1*a.dim1, a.dim2*a.dim2);
jmax=0;
for j=1:a.dim2
    jmin=jmax+1;
    jmax=jmax+a.dim2;
    imax=0;
    for i=1:a.dim1
        imin=imax+1;
        imax=imax+a.dim1;
        k=k+1;
        M(imin:imax, jmin:jmax)= reshape(a.data.X(k,:), a.dim2, a.dim1)';
    end
end

% Space with background
maxv=max(max(M));
minv=min(min(M));
bcg=(maxv+minv)/2;
%bcg=maxv;
col = bcg*ones(a.dim1,2);
line = bcg*ones(1,size(M,2)+2*(a.dim2+1));

IMG=line;
for i=1:a.dim1
    mini=(i-1)*a.dim1+1;
    maxi=i*a.dim1;
    LINE=col;
    for j=1:a.dim2
        minj=(j-1)*a.dim2+1;
        maxj=j*a.dim2;
        LINE=[LINE, M(mini:maxi,minj:maxj), col];
        ll=size(LINE,2);
    end
    line = bcg*ones(1,size(IMG,2));
    IMG=[IMG; LINE; line];
end    
    
% Display

map=gray(num);
Y = inormalize(-IMG);
warning off
Y = uint8(Y*(num-1));
if(~noshow) 
    figure;
    colormap(map);
    image(Y); 
end
warning on



title('Hadamard bank');