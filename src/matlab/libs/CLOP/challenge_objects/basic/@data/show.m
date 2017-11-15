function show(Data, prepro, nosort)
%show(Data, prepro, nosort)
% Graphical display of Data
% Data          -- a data object
% prepro        -- a choice of 
%                   0: do nothing; 
%                   1: take log; 
%                   2: normalize&standardize; 
%                   3: Repeatedly normalize row and columns.
%                   4: take log and standardize
%                   5: only stadardize
% nosort        -- if 1, do not sort lines and columns
%                  otherwise, sort Y in ascending order;
%                  sort X 

% Isabelle Guyon -- isabelle@clopinet.com -- May 2007

if nargin<2 | isempty(prepro), prepro=0; end
if nargin<3, nosort=0; end

if ~isempty(Data.X)
    switch prepro
        case 1
            Data.X=log(1+Data.X);
        case 2
            Data=train(chain({normalize, standardize}), Data);
        case 3
            Data.X=my_normalize(Data.X);
        case 4
            Data=train(chain({shift_n_scale('take_log=1'), standardize}), Data);
        case 5
            Data=train(standardize, Data);
    end
end

[p,n]=get_dim(Data);
if nosort
    pidx=1:p;
else
    [m, pidx]=sort(Data.Y(:,1));
end

Name=Data.algorithm.name;
Name(find(Name=='_'))='-';
Name=[Name(1:min(50, length(Name))), ' ...'];

% Sort X according to correlation with Y
if 1==2 % Don't do that ~nosort
    [d,m]=train(Pearson, Data);
    Data.X=Data.X(:,m.fidx);
end
X=Data.X(pidx,:);
% Put Y in the same scale as X
Y=Data.Y(pidx,:);
Ym=min(min(Y));
YM=max(max(Y));
Xm=min(min(X));
XM=max(max(X));
Y=(Y-Ym)/(YM-Ym);
Y=Y*(XM-Xm)+Xm;

% Display Y
cmat_display([X, Y(:,ones(ceil(n/100),1))]);
set(gcf, 'name', 'Heat map'); 
title(Name);

% Show correlation matrix
if size(Y, 2)>1
    cmat_display(corrcoef(Y));
    set(gca, 'XTick', 1:length(T));
    set(gca, 'XTicklabel', T);
    rotateticklabel(gca, 90);
    set(gca, 'YTick', 1:length(T));
    set(gca, 'YTicklabel', T);
    title(['Correlation matrix of:' Name]);
end

function X=my_normalize(X, bias)

if nargin<2, bias=0; end

mini=min(min(X));
if mini<=0
    maxi=max(max(X));
    X=(X-mini)/(maxi-mini)+bias;
    idx=find(X<=0);
    X(idx)=Inf;
    epsi=min(min(X));
    X(idx)=epsi;
end
X=log(X);
X=med_normalize(X);
X=med_normalize(X')';
X=med_normalize(X);
X=med_normalize(X')';
X=tanh(0.1*X);


function X=med_normalize(X)

mu=mean(X,2);
One=ones(size(X,2),1);
XM=X-mu(:,One);
S=median(abs(XM),2);
X=XM./S(:,One);
