function weights = get_w(the_model,method) 

%
%               w = get_w() 
% 
%   Returns the weight vector from the model 
% If method is given, return only the top ranking values.


weights=the_model.W;
if nargin>1
    weights=weights(get_fidx(the_model));
end
