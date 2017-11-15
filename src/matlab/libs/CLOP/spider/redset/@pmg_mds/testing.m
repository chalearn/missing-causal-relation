function d =  testing(a,d)

if(a.kp.algorithm.trained==0)
	disp('train me first, or give kpca which is trained');
    return;
end


if(isempty( a.dn) )
	a.dn=a.kp.dat;	
end

if( isempty(a.rn))
	a.rn=test(a.kp,a.dn);	
end


Nr=get_dim(d);


nn=knn;
nn.k=a.n;
nn.no_train=1;
[r,nn]=train(nn,a.rn);
nn.output_preimage=1;

inpdim=size(a.kp.dat.X,2);
X=[];

all_neighbours=test(nn,d);

for itemnr=1:Nr
    psi=all_neighbours.X(itemnr,:);
	
	feature_space_distances=calc(distance,get(a.rn,psi),get(d,itemnr)).^2;
	input_space_distances=feval(a.map,a,[],[],feature_space_distances);

    x=get_x(a.dn,psi);
    mx=mean(x);
    x=x-ones(a.n,1)*mean(x);

    d0=diag(x*x');
	
    
	zstar= minres(2*x'*x,x'*(d0-input_space_distances'))+mx';
    X=[X;zstar'];    
end

d=set_x(d,X);
d=set_name(d,[get_name(d) ' -> ' get_name(a)]); 



