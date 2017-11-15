function d =  testing(a,d)

% Modified by IG to comply with Spider interface
  
x = get_x(d); 
 
Yest = fwd(a.gkm, x);

if a.algorithm.use_signed_output

   Yest = sign(Yest);

end

d.X=Yest;  
d = set_name(d, [get_name(d) ' -> ' get_name(a)]); 
 
