function a = mrank(hyper) 
%============================================================================
% Manifold Ranking 
%============================================================================  
% a = mrank(hyperParam) 
%
% Generates an mrank object with given hyperparameters.
%
%
%   Hyperparameters (with defaults)
% 
%   child=kernel('rbf')  -- the kernel is stored as a member called "child"
%   alpha=0.99           -- parameter governing convergence rate
%   iterations=600       -- number of iterations of algorithm
%   use_edge_graph=0     -- if turned on, sparsify kernel using edge graph
%   normalize=0          -- normalize in the input space? 1 yes, 0 no
%   standardize=[]       -- centre and standardize data? 1 yes, 0 no
%                           default behaviour is to do so, except for
%                           linear and polynomial-based kernels
%                           (good for maintaining sparsity).
% 
% Methods:
%    TRAIN, TEST, PLOT
% 
%    There is no real need to split the algorithm into TRAIN and TEST
%    phases - this is done for consistency with other algorithm classes.
%    If labels are supplied in DAT.y, a single call to TRAIN is sufficient.
%    If DAT.y is empty, TRAIN merely stores the data in the algorithm
%    object, waiting for query points to be supplied by TEST.
% 
%    [DAT, A] = TRAIN(A, DAT);
% 
%    Points with Y=0 within DAT are considered unlabelled, and points with
%    non-zero Y are the query points. The unlabelled points are ranked
%    according to their similarity to the query points, computed via an
%    iterative spreading activation network algorithm. A.result on exit
%    contains [I S R] where I is the original index, S the ranking score
%    and R the rank of each point. Results can be plotted with PLOT(A).
%    DAT is unchanged.
% 
%    DAT = TEST(A, DAT)
% 
%    If DAT contains labels, throw away data stored in A and procede using
%    DAT as for TRAIN. If not, use DAT as the query points, and use any
%    unlabelled points from the data stored in A as the unlabelled points
%    (stored labelled points, i.e. those that were used as query points in
%    the previous run, are removed). On exit, the y field of DAT contains
%    ranking scores. The results can be plotted with PLOTRANKING(DAT).
% 
%    PLOT(A) -- see HELP MRANK/PLOT
% 
% d = gen(spiral({'m=100','n=0.5','noise=0.35'}));
% labelled = [50];
% d.Y = double(ismember([1:length(d.Y)]', labelled));
% 
% a = mrank;
% a.child = kernel('rbf',0.1);
% a.use_edge_graph = 1;
% 
% [dd aa] = train(a, d);
% plot(aa, 'etrc')
%      % (plots [e]dge graph, minimal spanning [t]ree, [r]anking and [c]onvergence)
% 
%============================================================================
% Reference : Ranking on Data Manifolds
% Author    : Dengyong Zhou , Jason weston , Arthur Gretton , OlivierBousquet and Bernhard Schölkopf
% Link      : http://www.kyb.tuebingen.mpg.de/publications/pdfs/pdf2290.pdf
%============================================================================

% Previous Example (too much code!!):
% d=gen(spiral({'m=100','n=0.5','noise=0.35'}));
% hold on;
% plot(d.X(:,1),d.X(:,2),'k.');
% I=randperm(200);
% label=['r+','','bo']
% Ipos=find(d.Y==1); I1=randperm(length(Ipos));
% p=plot(d.X(Ipos(I1(1)),1),d.X(Ipos(I1(1)),2),'ro'); set(p,'MarkerSize',10,'MarkerFaceColor',[1,0,0]);
% d.Y=d.Y*0;
% d.Y(Ipos(I1(1)),:)=1;
% axis off;
% mr=mrank;
% mr.child=kernel('rbf',0.1);
% [r,a]=train(mr,d)
% r.Y=a.result(:,3);
% I=find(~isnan(r.Y));
% for i=1:length(I)
%     
%     s=r.Y(I(i),:)/max(r.Y);
%     s=1/exp(s);
%     if(s<1)
%         p=plot(r.X(I(i),1),r.X(I(i),2),'o');
%         set(p,'MarkerFaceColor',[s,0,0])
%         set(p,'Color',[s,0,0])
%         set(p,'MarkerSize',10*s);
%     else
%         p=plot(r.X(I(i),1),r.X(I(i),2),'o');
%         set(p,'MarkerFaceColor',[1,0,0])
%         set(p,'Color',[1,0,0])
%         set(p,'MarkerSize',10*s);
%     end
% end
% p=plot(d.X(Ipos(I1(1)),1),d.X(Ipos(I1(1)),2),'go'); set(p,'MarkerSize',10,'MarkerFaceColor',[0,1,0]);
% 
%============================================================================
% Reference : Ranking on Data Manifolds
% Author    : Dengyong Zhou , Jason weston , Arthur Gretton , OlivierBousquet and Bernhard Schölkopf
% Link      : http://www.kyb.tuebingen.mpg.de/publications/pdfs/pdf2290.pdf
%============================================================================

  %<<------hyperparam initialisation------------->> 
  a.child = kernel('rbf');
  a.alpha = 0.99;
  a.iterations=600;
  a.use_edge_graph = 0;  
  a.normalize=0;
  a.standardize = [];
  
  % <<-------------results----------------->> 
  a.dat = [];
  a.edge_graph=[];
  a.result = [];
  a.convergence = [];
  a.mst = [];
  
  algoType=algorithm('mrank');
  a= class(a,'mrank',algoType);

  a.algorithm.alias={'kern','child'}; % kernel aliases
  
 if nargin==1,
    eval_hyper;
 end;
