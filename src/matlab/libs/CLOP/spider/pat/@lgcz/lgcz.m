function a = lgcz(hyper) 
%============================================================================
% Semi-Supervised Learning by Zhou et al. 
%============================================================================
% a=lgcz(hyperParam) 
%
% Generates a lgcz object with given hyperparameters.
% Can use unlabeled data (Y=0) to solve classification problem.
% After label propagation a SVM is trained to provide an inductive model.
% 
% Hyperparameters (with defaults)
%   child=kernel         -- the kernel is stored as a member called "child"
%   propkern=kernel         -- the kernel which is used for propagation
%   ridge=1e-13          -- a ridge on the kernel
%    wide                --  the width of label propagation 
% 
% Model
%    alpha               -- lagrangian multipliers
%    Xsv                 -- support vectors
%
% Methods:
%  train, test, get_w 
% 
% Example:
% c1=[2,0];
% c2=[-2,0];
% X1=randn(50,2)+repmat(c1,50,1);
% X2=randn(50,2)+repmat(c2,50,1);
% Y= 0*[ones(50,1);-ones(50,1)];    % kill all labels
% Y(1)=1;
% Y(end)=-1;            % provide only two labelled points
% d=data([X1;X2],Y);
% clf;
% hold on;
% l=lgcz('ridge=1e-10');
% l.child=kernel('rbf',1)
% l.propkernel=kernel('rbf',0.1)
% [r,a]=train(l,d)
% plot(a)
% p=plot(d.X(1,1),d.X(1,2),'go');set(p,'MarkerFaceColor',[0,1,0]);
% p=plot(d.X(end,1),d.X(end,2),'go');set(p,'MarkerFaceColor',[0,1,0]);
% ['only green dots were labelled']
%============================================================================
% Reference : Learning with Local and Global Consistency
% Author    : Dengyong Zhou 
% Link      : http://www.kyb.mpg.de/publication.html?user=zhou
%============================================================================

  %<<------hyperparam initialisation------------->> 
  a.propkern=kernel('rbf',1e-1);
  a.W=[];
  a.S=[];
  a.D=[];
  a.child=kernel;
  a.C=Inf;
  a.ridge=1e-13;  
  a.balanced_ridge=0;
  a.nu = 0;
  a.optimizer='default';
  a.alpha_cutoff=-1;
  
  
  % <<-------------model----------------->> 
  a.alpha=[];
  a.wide=1-1e-2;
  a.b0=0;
  a.Xsv=[];
  a.nob=0;
  

  algoType=algorithm('lgcz');
  a= class(a,'lgcz',algoType);

  a.algorithm.alias={'kern','child'}; % kernel aliases
 
 if nargin==1,
    eval_hyper;
 end;





