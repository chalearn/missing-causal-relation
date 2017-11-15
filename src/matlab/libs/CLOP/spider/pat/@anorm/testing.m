function d =  testing(a,d)
  
 Kt=get_x(a.Xsv)*get_x(d)';
 Yt=get_y(d);
 
 Yest=((a.alpha'* Kt)+a.b0)';
 Yest=sign(Yest);
   
 d=set_x(d,Yest); 
 d=set_name(d,[get_name(d) ' -> ' get_name(a)]); 
 
 

 
