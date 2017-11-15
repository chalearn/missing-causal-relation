function h=roc(D, h, col)
%h=roc(D, h, col)
% Plot ROC curve
% h=figure handle
% col=color

% Isabelle Guyon -- isabelle@clopinet.com -- June 2007

if nargin<2, h=figure; end
if nargin<3, col='k'; end

X=[]; Y=[];

p=length(D.child);
for i=1:p
    X=[X; get_x(D.child{i})];
    Y=[Y; get_y(D.child{i})];
end

if size(X, 2)==1
    roc(X, Y, [],[],[],[],h,col);
else
    fprintf('Not a data result object\n');
end