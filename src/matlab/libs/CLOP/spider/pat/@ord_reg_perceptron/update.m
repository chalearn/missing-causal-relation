function a=  update(a,d,U)

names=get_x(d); % extract data
numbers=get_y(d);
load([names(1,:) num2str(numbers(1))]) % load data

alpha = a.alpha + U*X;

a.alpha = alpha;
