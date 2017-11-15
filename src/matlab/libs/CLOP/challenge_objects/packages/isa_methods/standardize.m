function vs=standardize(v)
%vs=standardize(v)
% subtract mean and divide by standard deviation.

% Isabelle Guyon -- isabelle@clopinet.com -- June 2004

[n,p]=size(v);
if p~=1,
    v=v(:); 
    vs=(v-mean(v))./std(v);
    vs=reshape(vs,n,p);
else
    vs=(v-mean(v))./std(v);
end

