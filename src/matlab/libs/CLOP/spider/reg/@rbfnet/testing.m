function d =  testing(a,d)
  
ker=kernel('rbf',sqrt(1/(2*a.gamma)));
K=calc(ker,data(a.centers),d);
Yest=K*a.alpha;

if(a.algorithm.use_signed_output==1)
    Yest=sign(Yest);
end

 d=set_x(d,Yest); 
 d=set_name(d,[get_name(d) ' -> ' get_name(a)]); 
