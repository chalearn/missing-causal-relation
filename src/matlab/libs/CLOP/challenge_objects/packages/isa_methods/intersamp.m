function [xsamp, ysamp] = intersamp( xval, knots )
%[xsamp, ysamp] = intersamp( xval, knots  )
% Subsample data and gives a "uniform" y value
% knots: number of samples

% Isabelle Guyon -- isabelle@clopinet.com -- October 2012

if nargin<2, knots=10, end

xval=unique(xval);
yval=tiedrank(xval);

n=length(yval);
mini=min(yval);
maxi=max(yval);
inter=maxi-mini;
ysamp=mini:inter/(knots-1):maxi;
xsamp=zeros(size(ysamp));
for k=1:length(ysamp)
    [~, i]=min(abs(yval-ysamp(k)));
    xsamp(k)=xval(i);
end
%figure; plot(xsamp, ysamp, 'o');
