function K = entropy(kern,d1,d2,ind1,ind2,kerparam),

% Define your kernel like this function, just replace YOUR_KERNEL
%   and define the function below, between matrices
%   get_x(d2,ind2) and get_x(d1,ind1), e.g K = get_x(d2,ind2)*get_x(d1,ind1)';
%   for a linear kernel.


x1 = get_x(d2,ind2);
x2 = get_x(d1,ind1);
gamma = kerparam;
% take the exponents
exp1 = exp(x1);
exp2 = exp(x2);
%find the sizes
[row1 col1] =  size(x1);
[row2 col2] = size(x2);

%we will make a row1 x row2 kernel matrix
for i=1:1:row1
    for j=1:1:row2
        z = x1(i,:)-x2(j,:);
        expz = exp1(i,:)-exp2(j,:);
        K(i,j) = sum(z.*expz);
    end
end

K = exp(-gamma*K.*K);     

return;