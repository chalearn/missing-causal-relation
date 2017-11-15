function [h,A,Canvas,patches,pax] = scatterplot(X, Y, imput)
%[h,A,Canvas,patches,pax] = scatterplot(X, Y)
% Creates scatter plots of the columns of X.
% On the diagonal, make a histogram.
% Y provides optional class labels.
% Inputs:
% X     --      Matrix of column vectors, each column representing a dimension.
% Y     --      Vector of 0,1,2..., c class labels
% Alternatively, 
% [h,A,Canvas,patches,pax] = scatterplot(D)
% D is a spider data structure, D.X, D.Y
%
%   [H,AX,Canvas,P,PAx] = PLOTMATRIX(...) returns a matrix of handles
%   to the objects created in H, a matrix of handles to the individual
%   subaxes in A, a handle to big (invisible) axes that frame the
%   subaxes in Canvas, a matrix of handles for the histogram plots in
%   P, and a matrix of handles for invisible axes that control the
%   histogram axes scales in PAx.  Canvas is left as the CurrentAxes so
%   that a subsequent TITLE, XLABEL, or YLABEL will be centered with
%   respect to the matrix of axes.

% Isabelle Guyon -- isabelle@clopinet.com -- October 2002

if nargin<2, Y=[]; end
if isa(X, 'data')
    Y=X.Y;
    X=X.X;
end
[p,n]=size(X);
if isempty(Y), Y=zeros(p,1); end
if 1==2
    if min(min(Y))==-1 % Assumes 2 classes +-1; red is -1; black is +1
        Y=(Y+1)/2;
        col='crkbgmcrkbgmcrkbgmcrkbgmcrkbgm';
        sym='++o+++ooooooddddddxxxxxxssssss';
    else % We add an intermediate class that is blue
        col='crbkgmcrbkgmcrbkgmcrbkgmcrbkgm';
        sym='++.o++ooooooddddddxxxxxxssssss';
    end
end
% Assumes 2 classes +-1; red is +1; blue is -1 or 0
if (size(unique(Y),1) == 2)
    if min(min(Y))==-1 
        Y=(Y+1)/2;
    end
end

% Assumes 3 classes classes +-1 and missing data 0; red is +1; blue is -1 and black is 0
if (size(unique(Y),1) == 3)
    Y(Y==0)=2;
    Y(Y==-1)=0;
end

% Assumes 3 classes classes +-1 and missing data 0; red is +1; blue is -1 and black is 0
if (size(unique(Y),1) == 4)
    Y(Y==2)=3;
    Y(Y==-1)=0;
    Y(Y==-2)=2;
end
col2='cbrkgmcrbkgmcrbkgmcrbkgmcrbkgm';
if ~imput
    col = [0 1 1; 1 0 0; 0 0 1; 1 .7 0; 1 .7 0; 1 .7 0; 0.5 1 0; 0 0 0];
    sym='+..xp+ooooooddddddxxxxxxssssss';
else
    col = [0 1 1; 1 0 0; 0 0 1; 1 0 0; 0 0 1; 0.5 1 0; 0 0 0];
    sym='+..xx+ooooooddddddxxxxxxssssss';
end
        
if ndims(X)>2 | ndims(Y)>2, error('X an Y must be 2 dim'); help scatterplot; end
if (ndims(X)==2) & any(size(X)==1), X = X(:); end
if length(Y)~=p, error('Bad Y length'); help scatterplot; end
if (p==0 | n==0) 
    if nargout>0, h = []; A = []; Canvas = []; end
    return; 
end
    
coln=length(col);
%cmap=make_cmap(col);
cmap=col(2:end,:);

% Create Canvas and make it invisible
Canvas = newplot;
next = lower(get(Canvas,'NextPlot'));
hold_state = ishold;
set(Canvas,'Visible','off','color','none')
markersize = get(0,'defaultlinemarkersize');

% Find class labels
cl=unique(Y);
cl_num=length(cl);
cl_idx=cell(cl_num,1);
for k=0:cl_num-1
    cl_idx{k+1}=find(Y==k);
end

% Create axes and plot
A = zeros(n,n);
pos = get(Canvas,'Position');
width = pos(3)/n;
height = pos(4)/n;
space = .02; % 2 percent space between axes
pos(1:2) = pos(1:2) + space*[width height];

%%%%%%%%%[m,q,k] = size(y);
xlim = zeros([n n 2]);
ylim = zeros([n n 2]);
for i=n:-1:1,
    for j=n:-1:1,
        axPos = [pos(1)+(j-1)*width pos(2)+(n-i)*height width*(1-space) height*(1-space)];
        findax = findobj(gcf,'Type','axes','Position',axPos);
        if isempty(findax),
            A(i,j) = axes('Position',axPos);
            set(A(i,j),'visible','on');
        else
            A(i,j) = findax(1);
        end
        for k=1:cl_num
            SS=sym(mod(k, coln)+1);
            hh(i,j,:) = plot(X(cl_idx{k},j), X(cl_idx{k},i), SS, 'Color', col(mod(k, coln)+1,:))';
            hold on
            if SS=='.', 
                set(hh(i,j,:),'markersize',1.5*markersize);
            else
                set(hh(i,j,:),'markersize',0.7*markersize);
            end
        end

        set(A(i,j),'xlimmode','auto','ylimmode','auto','xgrid','off','ygrid','off')
        xlim(i,j,:) = get(gca,'xlim');
        ylim(i,j,:) = get(gca,'ylim');
    end
end

xlimmin = min(xlim(:,:,1),[],1); xlimmax = max(xlim(:,:,2),[],1);
ylimmin = min(ylim(:,:,1),[],2); ylimmax = max(ylim(:,:,2),[],2);

xlimmin = [-4 -4]; xlimmax = [4 4];
ylimmin = [-4;-4]; ylimmax = [4; 4];
% Try to be smart about axes limits and labels.  Set all the limits of a
% row or column to be the same and inset the tick marks by 10 percent.
inset = .15;
for i=1:n,
  set(A(i,1),'ylim',[ylimmin(i,1) ylimmax(i,1)])
  dy = diff(get(A(i,1),'ylim'))*inset;
  set(A(i,:),'ylim',[ylimmin(i,1)-dy ylimmax(i,1)+dy])
end
for j=1:n,
  set(A(1,j),'xlim',[xlimmin(1,j) xlimmax(1,j)])
  dx = diff(get(A(1,j),'xlim'))*inset;
  set(A(:,j),'xlim',[xlimmin(1,j)-dx xlimmax(1,j)+dx])
end

set(A(1:n-1,:),'xticklabel','')
set(A(:,2:n),'yticklabel','')
set(Canvas,'XTick',get(A(n,1),'xtick'),'YTick',get(A(n,1),'ytick'), ...
          'userdata',A,'tag','PlotMatrixCanvas')

% Put a histogram on the diagonal 
nx=100;
for i=n:-1:1,
    histax = axes('Position',get(A(i,i),'Position'));
    nnn=[];
    delta=(xlimmax(i)-xlimmin(i))/nx;
    xx=[xlimmin(i)+delta/2:delta:xlimmax(i)];
    for k=1:cl_num
        nn = hist(X(cl_idx{k},i), xx);
        nnn = [nnn; nn];
    end
    patches(i,:) = bar(xx,nnn','hist');
    colormap(cmap(1:cl_num,:));
    set(histax,'xtick',[],'ytick',[],'xgrid','off','ygrid','off');
    set(histax,'xlim',[xlimmin(1,i)-dx xlimmax(1,i)+dx])
    pax(i) = histax;  % A handles for histograms
end
  patches = patches';

% Make Canvas the CurrentAxes
set(gcf,'CurrentAx',Canvas)
if ~hold_state,
   set(gcf,'NextPlot','replace')
end

% Also set Title and X/YLabel visibility to on and strings to empty
set([get(Canvas,'Title'); get(Canvas,'XLabel'); get(Canvas,'YLabel')], ...
 'String','','Visible','on')

if nargout~=0,
  h = hh;
end

return

%function cmap=make_cmap(col)

% Red 1 0 0
% Green 0 1 0
% Blue 0 0 1
% black 0 0 0
% magenta 1 0 1
% cyan 0 1 1
% Yellow 1 1 0
%colcode='rgbkmc';
%colmat=[1 0 0; 0 1 0; 0 0 1; 0 0 0; 1 0 1; 0 1 1];

%for k=2:length(col)
%    pos=strfind(colcode, col(k));
%    cmap(k-1,:)=colmat(pos,:);
%    cmap(k-1,:)=col(k,:);
%end
