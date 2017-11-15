function d =  testing(a,d)
  
  
 Yest=(a.w'*get_x(d)'+a.b0)';

 if (a.algorithm.use_signed_output==1)
   Yest=sign(Yest);
 end
 
 d=set_x(d,Yest); 
 d=set_name(d,[get_name(d) ' -> ' get_name(a)]); 
 
 

 
