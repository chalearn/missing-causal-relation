function [yy,st]=genseq(alg,len,A,pi,B)

st=zeros(1,len);
yy = zeros(1,len);

ff=find(rand<pi); 
st(1) = ff(1);
ff=find(rand<B(:,st(1)));
yy(1) = ff(1);

for tt=2:len
    if(~issparse(A))
        ff=find(rand<A(st(tt-1),:)); 
    else
        ff=find(rand<cumsum(A(states(tt-1),:)));
    end
    st(tt) = ff(1);    
    ff=find(rand<B(:,st(tt)));
    yy(tt) = ff(1);
end