function d = ld_test(a, d)
%d = ld_test(a, d)
% Make predictions with the linear discriminant method.
% Inputs:
% a -- A linear discriminant model.
% d -- A data structure.
% Returns:
% d -- The same data structure, but X is replaced by the discriminant
% values.

% Isabelle Guyon -- September 2005 -- isabelle@clopinet.com

if a.algorithm.verbosity>1
    disp(['running ld_test...'])
end
  
Xte=get_x(d); 
[p, n]=size(Xte);

if p==0, 
    d=set_x(d,[]);
    return
end

Yest = Xte*a.W' + a.b0(ones(p,1),:);

% remove ties:
Yest(Yest==0)=a.algorithm.default_output*eps;

d=set_x(d,Yest); 