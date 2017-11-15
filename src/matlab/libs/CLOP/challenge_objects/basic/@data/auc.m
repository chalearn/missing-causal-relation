function [a, e]=auc(D)
% [a, e]=auc(D)
% Area under the ROC curve and error bar

a=[]; e=[];
if ~size(D.X, 2)==1    
    fprintf('Not a data result object\n');
    return
end

Yhat=get_x(D);
Y=get_y(D);
[a, e]=auc(Yhat, Y);

