function [b, e]=mse(D)
%[b, e]=mse(D)
% Mean square error and error bar

B=[];
p=length(D.child);
for i=1:p
    Yhat=get_x(D.child{i});
    Y=get_y(D.child{i});
    B(i)=mean((Yhat - Y).^2);
end
b=mean(B);
e=std(B)/sqrt(p);


