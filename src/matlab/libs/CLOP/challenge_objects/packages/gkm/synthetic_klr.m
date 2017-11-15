%
% SYNTHETIC - Kernel logistic regression on Ripley's synthetic dataset
%

% start from a clean slate

clear all;

% unbuffer the display

% unbuffer % IG COMMENTED OUT: crash under windows

% load data

load synthetic.mat

net = spider_klr;

% train model using spider

d_train = data(x_train, y_train);
d_test  = data(x_test,  y_test);

net.algorithm.use_signed_output=0; 

[o_train,net] = train(net, d_train);
o_test        = test(net, d_test);

% plot results

fprintf(1, 'plotting results...\n');

x = x_train;
y = y_train;
figure(1);
clf;
set(axes, 'FontSize', 14);
h1 = plot(x(y == 1, 1), x(y == 1, 2), 'rx');
hold on;
h2 = plot(x(y == 0, 1), x(y == 0, 2), 'b+');
a = axis;
[X,Y] = meshgrid(a(1):0.025:a(2),a(3):0.025:a(4));
X2    = [reshape(X,prod(size(X)),1) reshape(Y,prod(size(X)),1)];
o     = get_y(test(net, data(X2)));
o     = reshape(o,size(X));
hold on
[c,h4] = contour(X, Y, o, [+0.9 +0.9], 'r--');
[c,h5] = contour(X, Y, o, [+0.5 +0.5], 'g-');
[c,h6] = contour(X, Y, o, [+0.1 +0.1], 'b-.');
hold off
handles = [h1 ; h2 ; h4(1) ; h5 ; h6];
set(handles, 'LineWidth', 1);
legend(handles, 'class 1', 'class 2', 'p = 0.9', 'p = 0.5', 'p = 0.1', 'Location', 'NorthWest');
xlabel('x_1');
ylabel('x_2');
drawnow;

% bye bye...

