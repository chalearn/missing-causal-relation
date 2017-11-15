function K = poly_with_bias(kern,dat1,dat2,ind1,ind2,kerParam)

% K = poly_with_bias(kern,dat1,dat2,ind1,ind2,kerParam)
% compute the kernel matrix between d1 and d2
% for a polynomial kernel (<x,z>+kerParam(1))^kerParam(2) where x is from d1 and z from d2

% Isabelle Guyon -- isabelle@clopinet.com --September 2005
% Imitated from spider kernel poly 

X2 = get_x(dat2,ind2);
X1 = get_x(dat1,ind1);

K=(X2*X1'+kerParam(1)).^kerParam(2);  
