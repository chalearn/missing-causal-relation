function [s,it]=display(d,tab,it)

if nargin>1
    [s,it]=display(d.algorithm,tab,it);
    return;
end

disp(d.algorithm.name);

X= d.X;

disp(['data dimensions:'])
s = '[';
for i = 1:length(X)
    disp(['------------ Input ' num2str(i) ' ----------'])
    tmp = display(X{i});
    s=([s  tmp ' , ']);
end
disp('-------------------------------')
s = s(1:end-2);
disp([s ']  Y = ' num2str(size(d.Y,1)) 'x' num2str(size(d.Y,2)) ]);



