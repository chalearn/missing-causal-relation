function d =  testing(a,d)
  
K=calc(a.child.child,d,a.Xsv);
if length(a.alpha)==0
 Yest = d.Y*0;
else
 Yest = K'*a.alpha;
 for i=1:length(a.b0) 
     Yest(:,i)=Yest(:,i)+a.b0(i);     
 end
end
  
if a.algorithm.use_signed_output==1  
  Yest=sign(Yest);  
end  
d=set_x(d,Yest);    
d=set_name(d,[get_name(d) ' -> ' get_name(a)]); 