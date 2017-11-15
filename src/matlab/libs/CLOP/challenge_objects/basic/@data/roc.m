function h=roc(Data, h, col)
%h=roc(Data, h, col)
% Plot ROC curve
% h=figure handle
% col=color

% Isabelle Guyon -- isabelle@clopinet.com -- June 2007

if nargin<2, h=figure; end
if nargin<3, col='k'; end

if size(Data.X, 2)==1
    roc(Data.X, Data.Y, [],[],[],[],h,col);
else
    fprintf('Not a data result object\n');
end