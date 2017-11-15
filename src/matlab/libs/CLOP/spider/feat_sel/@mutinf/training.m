function [res,retAlg] =  training(a,d)

  disp(['training ' get_name(a) '.... '])  
  
  [X Y]  = get_xy(d);
  [numEx,vDim,oDim]=get_dim(d);
  feat=a.feat; % number of features desired   
  a.rank=[];
  if(~isempty(feat))
  	for i = 1:vDim			
		a.rank = [a.rank; -muteinf(X(:,i),Y,a.method) i];
		%fprintf(1, '.')
	end;		
	a.rank = sortrows(a.rank,1);		
	a.rank = a.rank(1:feat, 2);	
  else  	  		
	for i = 1:vDim		
%		[E V] = muteinfprob(X(:,i),Y, a.method);
		thresh = muteinf(rand(numEx,1),Y,a.method);
%		if(1 - normcdf(thresh, E, V) >= 0.95)				
		if muteinf(X(:,i),Y,a.method) > thresh
			a.rank = [a.rank i];
		end;
	end;
	a.feat=length(a.rank);
  end; 
  
  res = get(d,[],a.rank);
  res = set_name(res,[get_name(res) ' -> ' get_name(a)]);  
  if a.output_rank == 0	            
    [res,a.child]=train(a.child,get(d,[],a.rank));    
  end;
  retAlg=a; 
