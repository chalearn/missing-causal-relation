function [a, e]=auc(D)
% [a, e]=auc(D)
% Area under the ROC curve and error bar

B=[];
p=length(D.child);
for i=1:p
    Yhat=get_x(D.child{i});
    Y=get_y(D.child{i});
    a=auc(Yhat, Y);
    if isempty(a)
        a=0.5;
    end
    B(i)=a;
end
a=mean(B);
e=std(B)/sqrt(p);




