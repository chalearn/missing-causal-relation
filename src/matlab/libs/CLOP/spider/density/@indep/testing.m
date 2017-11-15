function d =  testing(a,d)
  
 if isempty(d) %% generate data according to model instead
   d=generate(a); return;
 end
 
 [l n k]=get_dim(d);
 Yest=zeros(l,n);
 
 for i=1:n
   Yest(:,i)=get_x(test(a.child{i},get(d,[],i)));
 end
 if n>1 Yest=prod(Yest')'; end;
   
 d=set_x(d,Yest); 
 d=set_name(d,[get_name(d) ' -> ' get_name(a)]); 
  
 




