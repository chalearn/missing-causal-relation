function sdigit=skew(digit, angle)
% sdigit=skew(digit, angle)
% Skew digit of angle alpha.

% Isabelle Guyon - isabelle@clopinet.com -- June 2004

[n,p]=size(digit);
i0=n/2;
j0=p/2;
sk=tan(angle);
sdigit=zeros(size(digit));
for i=1:n
    for j=1:p
        
        jj=j+(i-i0)*sk;
        j1=floor(jj);
        j2=ceil(jj);
        dj=jj-floor(jj);
        if j1>1 & j1<p & j2>1 & j2<p
            sdigit(i,j)=(1-dj)*digit(i,j1)+dj*digit(i,j2);
        end
        %if j1>1 & j1<p
        %    sdigit(i,j)=digit(i,j1);
        %end
        %fprintf('%d %d %d\n', i, j, j1);
    end
end
