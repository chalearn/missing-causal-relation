function d  =  testing(a,d)

alpha=a.child.alpha; 
svs=find(sum(abs(alpha)',1)>1e-5); 
K=calc(a.child.child,d,a.Xsv);

  
  Yest = K'*a.alpha;
   for i=1:length(a.b0) 
       Yest(:,i)=Yest(:,i)+a.b0(i);     
   end
   
  if a.algorithm.use_signed_output==1  
    Yest=sign(Yest);  
  end  
  d=set_x(d,Yest);    
  d=set_name(d,[get_name(d) ' -> ' get_name(a)]);   
   
   
