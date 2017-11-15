function d =  testing(a,d)
 
% try to simulate spectral clustering choice
% one nearest neighbor clustering afterwards 
  
Ktmp = calc(a.child,d,a.d); 
Ytmp = get_y(a.d);
[u,v] = min(Ktmp);
for i=1:size(Ktmp,2),
    Yest(i) = Ytmp(v(i)); 
end;

d=set_x(d,Yest');  d.name=[get_name(d) ' -> ' get_name(a)]; 
