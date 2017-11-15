function K = poly_rbf(kern,dat1,dat2,ind1,ind2,kerParam)
% K = poly_rbf(kern,dat1,dat2,ind1,ind2,kerParam)
% compute the kernel matrix between d1 and d2
%  (<x,z>+kerParam(1))^kerParam(2)*exp(-kerParam(3)*||x-z||^2)
% where x is from dat1 and z from dat2

% Isabelle Guyon -- isabelle@clopinet.com --September 2005
% Imitated from spider kernels poly and rbf

K=get_x(dat2,ind2)*get_x(dat1,ind1)';     % Dot product 
kernTemp=kernel;
Kdn = get_norm(kernTemp,dat1,ind1)'.^2;   % Norm 1
Kn  = get_norm(kernTemp,dat2,ind2).^2;    % Norm 2
K = ((K+kerParam(1)).^kerParam(2)).*exp(-kerParam(3)*(Kdn(ones(length(Kn),1),:) + Kn(:,ones(1,length(Kdn))) - 2*K));


