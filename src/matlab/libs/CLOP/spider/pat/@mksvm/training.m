function [retDat,algo] =  training(algo,retDat)

if algo.algorithm.verbosity>0
    disp(['training ' get_name(algo) '.... '])
end     
	y=get_y(retDat);         
	n=get_dim(retDat);
	Ktot=[];   
	k=length(algo.child);
        for i=1:k
        	[KerMa,algo.child{i}]=train(algo.child{i},retDat); 
        	KerMa=KerMa.X;    %% calc kernel		
        	KerMa=add_ridge(KerMa,algo,retDat); 
		KerMa=KerMa.*(y*y');
		Ktot=[Ktot KerMa];
	end	
        algo.C=min(algo.C,1e5);	
	opts= optimset('MaxIter',10000); 
	lower=zeros(1,n*(k+1)+1); upper=ones(1,n*(k+1)+1)*Inf;  		
  	alphas=linprog([ones(1,k*n) 0 algo.C*ones(1,n)],[-Ktot -y -eye(n)],-ones(1,n),[],[],lower,upper,[],opts);
	alpha=alphas(1:k*n);
	bias0=alphas(k*n+1);
%% 	slacks=alphas(k*n+2:length(alphas))
        alpha= alpha .* repmat(y,k,1);        
%% 	bias0=mean(y.*(1-slacks) - Ktot*alpha);
algo.b0=bias0;
algo.Xsv=retDat;
algo.alpha=reshape(alpha,n,k);
if algo.algorithm.do_not_evaluate_training_error
    retDat=set_x(retDat,get_y(retDat)); 
else
    retDat=test(algo,retDat);
end


