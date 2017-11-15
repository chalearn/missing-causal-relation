function res =  testing(a,d)
  
 X = get_x(d);
 mtest = size(X,1);

 Xtrain = get_x(a.Xsv);
 mtrain = size(Xtrain,1);
 
 
 tmp = zeros(mtest,a.M);
 tmp(:,1)=ones(mtest,1);
 
 for i=2:2:a.M,
      v = a.B(i,2);
      indprev = a.B(i,1);
      t = a.B(i,3);
      
      posx = (X(:,v)-Xtrain(t,v));
      negx = -posx;
      posx(find(posx<0))=0;
      negx(find(negx<0))=0;
      tmp(:,i) = tmp(:,indprev).*posx;
      tmp(:,i+1) = tmp(:,indprev).*negx;     
 end;

 dtmp = set_x(d,tmp(:,a.J));
 res = test(a.child,dtmp);
 
