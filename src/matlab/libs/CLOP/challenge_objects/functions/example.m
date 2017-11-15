function example(net, discri)
%
% Plots a small 2d example
% Gavin Cawley -- April 2008

if nargin<1, net=naive; end
if nargin<2, discri=1; end

load synthetic.mat
if discri
    y_train=2*y_train-1;
    y_test=2*y_test-1;
end

d_train = data(x_train, y_train);
d_test  = data(x_test,  y_test);

[o_train,net] = train(net, d_train);
o_test        = test(net, d_test);

% plot results

fprintf(1, 'plotting results...\n');

x = x_train;
y = y_train;
figure('name', get_name(net));
set(axes, 'FontSize', 14);
h1 = plot(x(y > 0, 1), x(y > 0, 2), 'ro');
hold on;
h2 = plot(x(y <= 0, 1), x(y <= 0, 2), 'b+');
a = axis;
[X,Y] = meshgrid(a(1):0.025:a(2),a(3):0.025:a(4));
X2    = [reshape(X,prod(size(X)),1) reshape(Y,prod(size(X)),1)];
o     = get_x(test(net, data(X2)));
o     = reshape(o,size(X));
hold on

contour(X, Y, o);
if discri
    [c,h4] = contour(X, Y, o, [+1 +1], 'r-');
    [c,h5] = contour(X, Y, o, [0 0], 'g-');
    [c,h6] = contour(X, Y, o, [-1 -1], 'b-');
else
    [c,h4] = contour(X, Y, o, [+0.9 +0.9], 'r-');
    [c,h5] = contour(X, Y, o, [+0.5 +0.5], 'g-');
    [c,h6] = contour(X, Y, o, [+0.1 +0.1], 'b-');
end
hold off
handles = [h1 ; h2 ; h4(1) ; h5 ; h6];
set(handles, 'LineWidth', 2);
if discri
    legend(handles, 'class 1', 'class 2', 'y = 1', 'y = 0', 'y = -1', 'Location', 'NorthWest');
else
    legend(handles, 'class 1', 'class 2', 'p = 0.9', 'p = 0.5', 'p = 0.1', 'Location', 'NorthWest');
end
xlabel('x_1');
ylabel('x_2');
drawnow;



