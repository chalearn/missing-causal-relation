function plot_feat(val, fidx, w, y)
%plot_feat(val, fidx, w, y)
% Show place of feature on digit image
% val = pixel values
% fidx = index of the features
% y = target

if nargin<3, w=[]; end
if nargin<4, y=[]; end

% Isabelle Guyon -- May 2005 -- isabelle@clopinet.com

show_digit(val); hold on

n=sqrt(length(val));
icoord=repmat([1:n]',1,n); icoord=icoord(:);
jcoord=repmat([1:n],n,1); jcoord=jcoord(:);

plot(icoord(fidx),jcoord(fidx), 'bo');

if ~isempty(y) & ~isempty(w)
    vali=y.*sign(w).*(val(fidx)-0.5)*2;
    
    posval=find(vali>=0);
    negval=find(vali<0);

    plot(icoord(fidx(posval)),jcoord(fidx(posval)), 'g+','LineWidth',4);
    plot(icoord(fidx(negval)),jcoord(fidx(negval)), 'r+','LineWidth',4);
end






