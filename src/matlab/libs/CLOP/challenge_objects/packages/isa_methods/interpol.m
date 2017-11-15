function y = interpol(x, xsamp, ysamp)
%y = interpol(x, xsamp, ysamp )
% Piecewise linear interpolation of ysamp fo inputs xsamp
% xsamp must be sorted.

% Isabelle Guyon -- isabelle@clopinet.com -- October 2012

n=length(xsamp);
y=zeros(size(x));
slope=(ysamp(2:end)-ysamp(1:end-1))./(xsamp(2:end)-xsamp(1:end-1));

[p, m]=size(x);
x=x(:);

vectorized=1; % much faster

if ~vectorized

    for k=1:length(x)
        [~, i]=min(abs(x(k)-xsamp));

        high_closest=x(k)>xsamp(i);
        %fprintf('k=%d i=%d c=%d\n', k, i, high_closest);
        if i==1 || high_closest
            y(k)=ysamp(i)+slope(i)*(x(k)-xsamp(i));
        else
            y(k)=ysamp(i)+slope(i-1)*(x(k)-xsamp(i));
        end
    end

else
    xx=x(:,ones(n,1)) - xsamp(ones(m*p,1), :);
    xx=abs(xx);
    [~, i]=min(xx,[],2);
    t=x>xsamp(i)';
    j=i; j(i==n)=n-1;
    sp=ysamp(i)'+slope(j)'.*(x-xsamp(i)');
    j=i; j(i==1)=2; j=j-1;
    sn=ysamp(i)'+slope(j)'.*(x-xsamp(i)');
    y=t.*sp+(1-t).*sn;
end

y=reshape(y, p, m);
