function a = rsc_fp(alg, hyper) 
%=================================================================
% Reduced set construction using Fixpoint method by Schölkopf et al.
%=================================================================
% a = rsc_fp(alg,hyper)
% generates a rsc object, using the fixpoint method
%
% hyperparameters:
% child=svm     algorithm worked on
% rsv=.5        if rsv e [0,1): #rsv = #sv * rsv
%               if rsv > 1: #rsv
% max_it=10     maximum of iterations per class
% eps=1e-5      epsilon
% 
% model:
% alpha         new alphas for rs-vectors
% Xsv           rs vectors
%
% stats:
% w2=0          final value of ||w-w*||^2 
% dw=0          total decrease in ||w-w*||^2 
%
% methods:
% train         constructs a reduced set, returns trained rs-machine
% test          tests new rs-machine on supplied data
%
% remark: 
% supports only rbf-kernels!
%
% example:
% d=gen(toy2d('2circles','l=100'));
% [r,a]=train(svm({kernel('rbf',1),'C=10000','alpha_cutoff=1e-2'}),d);
% [r,a2]=train(rsc_fp(a,'rsv=.3'),d);
% test(a2,d,loss)
%
%=================================================================
% author: b. schoelkopf et al.
% reference: learning with kernels, chpt. 18
%=================================================================


  % hyperparameters
  a.C=Inf;
  a.eps = 1e-5;
  a.max_it = 10;
  a.rsv = .5;
  a.stv = 3;
  a.child = svm;
  
  % model 
  a.alpha=[];
  a.b0=0;
  a.Xsv=[];
  
  % stats
  a.w2 = 0;
  a.delta_w = 0;
  a.dw = 0;
   
  if nargin==0
    a.child=svm;  
  else 
    a.child=alg; %% algorithm to use  
  end
  
  p = algorithm('rsc_fp');
  a = class(a,'rsc_fp',p);
  
  if nargin==2
    eval_hyper;
  end  