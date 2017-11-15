function d =  testing(a,d)
  
  d=get(d,[1:5]);
    
  K = get_kernel(a.child,a.X,d);
  if (a.use_b) K=K+1; end;
 
  
  
  r=[];
  for i=[-1 1]
    L=(get_y(a.X)*(i*ones(1,length(d.Y))));
    K2=K + L;
    Yest = K2*a.alpha;
    r=[r ; sum((K2-Yest).^2,1)];
  end
  
  r
  
  keyboard
  
  d=set_x(d,Yest); 
  d=set_name(d,[get_name(d) ' -> ' get_name(a)]); 
 
 







