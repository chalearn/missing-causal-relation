function weights = get_w(alg,method) 

%
%               w = get_w() 
% 
%   Returns the weight vector from the model 
% If method is given, return only the top ranking values.

n=length(alg.child);
weights=get_w(alg.child{n}, 1);
if nargin<=1
    w=zeros(size(get_fidx(alg.child{1})));
    idx_final=get_fidx(alg);
    w(idx_final)=weights;
    weights=w;
end
