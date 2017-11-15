function a = rsc_burges(alg, hyper) 
%=================================================================
% Reduced set construction by C.Burges 
%=================================================================
% a = rsc_burges(alg,hyper)
% generates a rsc object, using the burges method
%
% hyperparameters:
% child=svm     algorithm worked on
% rsv=.5        if rsv e [0,1): #rsv = #sv * rsv
%               if rsv > 1: #rsv
% max_it=100    maximum of iterations for gradient descent
% eps=1e-5      epsilon
% phase2=yes    perform burges phase2 ?
% minimizer=1   (1) gradient descent (0) conj. gradient
% stv=3         number of restarts
% deriv='der_rbf' use function, which name is supplied as string, as
%               function to calculate d||w-w*||^2/dz_l
%               if set to 'num', usee numerical derivative instead
% 
% model:
% alpha         new alphas for rs-vectors
% Xsv           rs vectors
%
% stats:
% w2=0          final value of ||w-w*||^2 
% delta_w=0     total decrease in ||w-w*||^2 
% dw=0          run through delta_w
%
% methods:
% train         constructs a reduced set, returns trained rs-machine
% test          tests new rs-machine on supplied data
%
% example:
% d=gen(toy2d('2circles','l=100'));
% [r,a]=train(svm({kernel('rbf',1),'C=10000','alpha_cutoff=1e-2'}),d);
% [r,a2]=train(rsc_burges(a,'rsv=.9'),d);
% test(a2,d,loss);
%
%=================================================================
% author: chris burges
% reference: simplified sv decision rules, 1996
%=================================================================


  % hyperparameters
  a.C=Inf;
  a.eps = 1e-4;
  a.max_it = 100;
  a.rsv = .5;
  a.stv = 3;
  a.child = svm;
  a.phase2 = 1;
  a.minimizer = 0;
  a.deriv='der_rbf';
  
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
  
  p = algorithm('rsc_burges');
  a = class(a,'rsc_burges',p);
  
  if nargin==2
    eval_hyper;
  end  