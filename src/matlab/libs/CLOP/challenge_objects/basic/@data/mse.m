function [m, e]=mse(D)
%m =mse(D)
% Mean square error

if ~size(D.X, 2)==1    
    fprintf('Not a data result object\n');
    return
end

Yhat=get_x(D);
Y=get_y(D);
m=mean((Yhat - Y).^2);
e=[];