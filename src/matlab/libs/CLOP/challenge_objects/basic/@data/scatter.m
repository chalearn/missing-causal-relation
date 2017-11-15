function scatter(Data, fidx)
%scatter(Data, fidx)
% 2 d scatterplot
% Data -- a data object
% fidx -- list of the features to display or 'all' to show them all

% Isabelle Guyon -- isabelle@clopinet.com -- May 2007

if nargin==2 && strcmp(fidx, 'all')
    fidx=Data.findex;
end
if nargin<2 || isempty(fidx), fidx=1:min(2, size(Data.X,2)); end

figure('name', ['Scatter plot ', num2str(fidx)]); 
scatterplot(Data.X(:,fidx),Data.Y);

Name=get_name(Data);
Name(find(Name=='_'))='-';
Name=[Name(1:min(50, length(Name))), ' ...'];
title(Name);