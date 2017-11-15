function [b, e]=ber(D)
%[b, e]=ber(D)
% Balanced error rate and error bar

B=[];
p=length(D.child);
for i=1:p
    Yhat=get_x(D.child{i});
    Y=get_y(D.child{i});
    B(i)=balanced_errate(Yhat, Y);
end
b=mean(B);
e=std(B)/sqrt(p);

