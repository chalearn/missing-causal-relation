function [Y, map] = gmat_display(X, num, noshow, h)
%[Y, map] = gmat_display(X, num, noshow, h)
% Display matrix X in gray levels after rescaling.
% Inputs:
% X -- matrix to be displayed (real neumbers).
% Optional:
% num -- number of gray levels (default 256).
% noshow -- a flag. If 1, the figure is not displayed.
% Returns:
% Y -- rescaled matrix X (in uint8, to make an image).

% Isabelle Guyon -- April 2002 -- isabelle@clopinet.com

if (nargin<2|isempty(num)), num=256; end
if (nargin<3|isempty(noshow)), noshow=0; end
if nargin<4, h=[]; end

map=gray(num);
if isempty(X), Y=[]; return, end;

Y = inormalize(X);
warning off
Y = uint8(Y*(num-1));
warning on
if(~noshow) 
    if isempty(h), h=figure; else figure(h); end
    colormap(map);
    image(Y); 
end



