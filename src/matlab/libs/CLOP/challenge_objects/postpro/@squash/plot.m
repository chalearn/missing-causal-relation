function plot(a, d, h)
%plot(a, d, h)

if nargin<3
    h=figure; 
else
    figure(h);
end
clf
hold on

plot(d.X, d.Y, '.');
dhat=test(a, d);

[sx, i]=sort(d.X);
xhat=dhat.X;
plot(sx, xhat(i), 'r-', 'LineWidth', 2);




