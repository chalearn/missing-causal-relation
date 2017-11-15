
function d = testing(a,d)
  
d = data(get_name(d),feval('calc',a,d,a.dat),d.Y);