function d =  testing(a,d)

names=get_x(d); % extract data
numbers=get_y(d);
m=get_dim(d); % m stores number of examples

yest=[];
for i=1:m;
    tmp = [];
%     disp(['Loading ' names(i,:) num2str(numbers(i))])
    load([names(i,:) num2str(numbers(i))]) % load data
    for j = 1:size(X,1)
        tmp = [tmp, a.alpha*X(j,:)'];
    end
    yest = [yest; tmp];
end

d.X=yest; 