function d =  testing(a,d)
  
 Kt=get_kernel(a.child,d,a.Xsv);
 Yt=get_y(d);
 
 Yest=((a.alpha'* Kt)+a.b0)';
 Yest=sign(Yest);
   
 d=set_x(d,Yest); 
 d=set_name(d,[get_name(d) ' -> ' get_name(a)]); 

 

 
