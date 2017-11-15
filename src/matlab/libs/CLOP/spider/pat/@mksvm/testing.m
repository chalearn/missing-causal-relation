function dat  =  testing(algo,dat)



  %% <<---To avoid large kernel matrices, we test in batches--->   
  k=length(algo.child);
  sz=get_dim(algo.Xsv);   %% <---500x500 point are the maximum for one batch
  batch_size=round((500^2)/sz);
  
  yEst=[];
  for i=[1:batch_size:get_dim(dat)]  	
    take= [i:min(i+batch_size-1,get_dim(dat))];
    
    ys=zeros(length(take),1);
    for j=1:k
    	kerMaTemp=get_kernel(algo.child{j},get(dat,take),algo.Xsv);    	
	ys = ys + (algo.alpha(:,j)'* kerMaTemp)';
    end
    yEst=[yEst; ys + algo.b0];
  end
  if algo.algorithm.use_signed_output==1
    yEst=sign(yEst);
  end

  dat=set_x(dat,yEst);
  dat=set_name(dat,[get_name(dat) ' -> ' get_name(algo)]); 
 
