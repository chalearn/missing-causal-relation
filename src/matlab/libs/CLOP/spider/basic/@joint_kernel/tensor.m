function K = tensor(kern,dat1,dat2,ind1,ind2,kerParam),

inplen = length(dat1.X);
if inplen ~= length(dat2.X)
    error('Number of input domains must be the same ')
end

% %%% temp %%%%%
% global mux;
% global muy;
% 
% 
% %%%%%%%%%%%%


X1 = get_x(dat2,ind2);
%X2 = get_x(dat1,ind1)';  
X2 = get_x(dat1,ind1);  



K = X1{1}*X2{1}';

for i = 2:inplen
    K = K.*(X1{i}*X2{i}');
end