function [Y, map] = show(a, num, noshow)
%[Y, map] = gmat_display(a, num, noshow)
% Display matrix X in gray levels after rescaling.
% Inputs:
% a -- kernel object.
% Optional:
% num -- number of gray levels (default 256).
% noshow -- a flag. If 1, the figure is not displayed.
% Returns:
% Y -- rescaled matrix X (in uint8, to make an image).
% The largest values are shown as black.

% Isabelle Guyon -- April 2002 -- isabelle@clopinet.com

if (nargin<2|isempty(num)), num=256; end
if (nargin<3|isempty(noshow)), noshow=0; end

map=gray(num);
X=get_x(a);
if isempty(X), Y=[]; return, end;

Y = inormalize(-X);
warning off
Y = uint8(Y*(num-1));
if(~noshow) 
    figure;
    colormap(map);
    image(Y); 
end
warning on


title(['Exponential kernel, sigma1=' num2str(a.sigma1) ' , sigma2=' num2str(a.sigma2)]);
