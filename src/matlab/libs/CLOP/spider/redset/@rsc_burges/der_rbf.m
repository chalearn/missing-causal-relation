function ret = der_rbf(a,alpha,gamma,sigma,Z,S,k,l)

% calculates derivative of ||w-w*||^2 with regard to row l of matrix X
% (only for z)
% i.e. d||w-w*||^2 / d z_l

z_l = Z(l,1:size(Z,2));
gamma_l = gamma(l,1);
 
dz = (2*gamma_l/sigma^2)* gamma' *diag(calc(k,data(Z),data(z_l)))* (Z-repmat(z_l,size(Z,1),1));
dz =  dz - (2*gamma_l/sigma^2)* alpha' *diag(calc(k,data(z_l),data(S)))* (S-repmat(z_l,size(S,1),1));
ret=dz';