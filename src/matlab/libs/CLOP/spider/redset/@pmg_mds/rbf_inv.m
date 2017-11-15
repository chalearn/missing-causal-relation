function r=rbf_inv(a,dn,psi,squared_feature_space_distances)
gamma= 1/(2*a.child.kerparam^2);
r=-1/gamma * log(1-1/2*squared_feature_space_distances);