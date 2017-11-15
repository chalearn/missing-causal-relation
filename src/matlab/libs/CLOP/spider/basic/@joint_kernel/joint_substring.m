function K = joint_substring(kern,dat1,dat2,ind1,ind2,kerParam),

inplen = length(dat1.X);
if inplen ~= length(dat2.X)
    error('Number of input domains must be the same ')
end



X1 = get_x(dat1,ind1); X2 = get_x(dat2,ind2);

K = calc(kernel('string_subsequence',kerParam),data_struct(X1{1}),data_struct(X2{1}));
for i = 2:inplen
    K = K.*calc(kernel('string_subsequence',kerParam),data_struct(X1{i}),data_struct(X2{i}));;
end