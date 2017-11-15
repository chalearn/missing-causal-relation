function [b, e]=ber(D)
%[b, e]=ber(D)
% Balanced error rate and error bar

if ~size(D.X, 2)==1    
    fprintf('Not a data result object\n');
    return
end

Yhat=get_x(D);Y=get_y(D);
[b, p, n, e]=balanced_errate(Yhat, Y);

