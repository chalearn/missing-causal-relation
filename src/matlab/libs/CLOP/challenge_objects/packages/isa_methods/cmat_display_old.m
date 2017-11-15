function [Y, map, h] = cmat_display(X, num, noshow, sat)
%[Y, map, h] = gmat_display(X, num, noshow, sat)
% Display matrix X in pseudo-color after rescaling and squashing to improve contrast.
% Inputs:
% X -- matrix to be displayed (real numbers).
% Optional:
% num -- number of gray levels (default 256).
% noshow -- a flag. If 1, the figure is not displayed.
% sat -- saturation level.
% Returns:
% Y -- rescaled matrix X (in uint8, to make an image).
% map -- colormap
% h -- image handle

% Isabelle Guyon -- April 2002-October 2002 -- isabelle@clopinet.com

if (nargin<2|isempty(num)), num=256; end
if (nargin<3|isempty(noshow)), noshow=0; else sat=-1; end
if (nargin<4), sat=0; end

if noshow==1, sat=-1; end

% Create a colormap
x=1:(num/2);
y=(num/2):-1:1;
b=[exp(-y/(num/8)),exp(-x/(num/8))];
r=[0.5+x/num,1-x/(num/2)];
g=[x/(num/2),1-x/num];
%plot(1:num,r,'r-',1:num,g,'g-',1:num,b,'b');

map=[g',r',b'];

if isempty(X), Y=[]; return, end;

if ~noshow, figure; end
if sat==0
    Y=X;
    if ~noshow, h=image(Y,'CDataMapping', 'scaled'); end
elseif sat==1
	m=min(min(X));
	M=max(max(X));
	T=min(abs(m),abs(M))/2;
    Y=T*tanh(X/T);
    if ~noshow, h=image(Y, 'CDataMapping', 'scaled'); end
else % sat==-1
    m=min(min(X));
	M=max(max(X));
    T=max(abs(m),abs(M));
    %Y=((X/T)+1)/2;
    Y = inormalize(X);
	Y = uint8(Y*(num-1));
    if ~noshow, h=image(Y); end
end

if(~noshow) 
    colormap(map);
    colorbar; 
end