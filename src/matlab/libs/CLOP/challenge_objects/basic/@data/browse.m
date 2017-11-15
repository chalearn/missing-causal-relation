function browse(Data, dim, Model, fnum)
%browse(Data, dim, Model, fnum)
% Graphical display of patterns
% Data -- a data object
% dim  -- dimension of the patterns (1 = vector, 2= square image)
% Model -- a trained feature selection model of a feature set
% num -- number of features to display

% Isabelle Guyon -- isabelle@clopinet.com -- August 2008

if nargin<2, dim=1; end
if nargin<4, w=[]; fnum=[]; end

if nargin<3, 
    Model=[]; fidx=[]; 
else
    if isnumeric(Model)
        fidx=Model;
    else
        fidx=get_fidx(Model);
    end
end
if isempty(fnum), fnum=size(fidx,2); end

if size(fidx,1)==1
    % We don't use the weights of the model but the correlations
    [d,m]=train(Pearson, Data);
    w=m.w;
else
    w=[];
end
[pnum, n]=get_dim(Data);
fnum=min(size(fidx, 2), fnum); 

if ~isempty(w), 
    fidx=fidx(ones(pnum,1), 1:fnum);
    w=w(fidx);
else
    w=Data.Y(:, ones(1,fnum)); 
    fidx=fidx(:,1:fnum);
end

N=size(Data.X, 1);
n=1;
p=-1;
e=0;
figure('name', 'Pattern browser');
num=1;
while 1

    if dim==2,
        if ~isempty(Model)
            plot_feat(Data.X(num,:), fidx(num,:), w(num,:), Data.Y(num));
        else
            show_digit(Data.X(num,:)); 
        end
    else
        if ~isempty(Model)
            plot(Data.X(num,Model.fidx(1:fnum)));
        else
            plot(Data.X(num,:));
        end
    end

    if isempty(Data.Y)
        title(['Index: ' num2str(num)]);
    else
        title(['Index: ' num2str(num) ' Class: ' num2str(Data.Y(num))]);
    end
    
    idx = input('Pattern number (or n for next, p for previous, e exit)? ');
    if isempty(idx), idx=n; end
    switch idx
    case n
        num=num+1;
        if num>N, num=1; end
    case p
        num=num-1;
        if num<1, num=N; end
    case e
        break
    otherwise
        num=idx;
    end
end


