function a = rss_l1(alg,hyper) 
%=================================================================
% Reduced set selection by L1 Penalizer.
%=================================================================
% a = rss_l1(alg,hyper)
% generates a rss object, using the l1 norm
%
% hyperparameters:
% child=svm         algorithm worked on
% reoptimize_b=1    recalculate the threshold b0
% alpha_cutoff=-1   throw away svs with abs(alpha)<n
% optimizer='andre' 
% a.lambda=0        regularizer for selection
%                   set to 0 for automatic selection
% penalize_small=1  min \sum (1/alpha_i) beta_i
% dont_use_noisy_pts=0 discards noisy points
% reoptimize=1    
% 
% 
% model:
% alpha         new alphas for rs-vectors
% Xsv           rs vectors
% b0            the threshold
% w2            final value of ||w*-w^2||^2, set to -1 to calculate
%
% stats:
% w2=0          final value of ||w-w*||^2 
% res=[]        results on a separate test set
% dtst=[]       separate test set  
% test_on=0     iterations to test on
%
% methods:
% train         constructs a reduced set, returns trained rs-machine
% test          tests new rs-machine on supplied data
%
% example:
% d=gen(toy2d('2circles','l=100'));
% [r,a]=train(svm({kernel('rbf',1),'C=10000','alpha_cutoff=1e-2'}),d);
% [r,a2]=train(rss_l1(a,'lambda=1e-2'),d);
% test(a2,d,loss)
%
%=================================================================
% author: goekhan bakir, jason weston
% reference: fast binary and multi-output rss, 2004
%=================================================================
  
  %hyperparams 
  a.child=svm;
  a.alpha_cutoff=-1;
  a.lambda=0;       % set to 0 for automatic selection
  a.penalize_small=1; % min \sum (1/alpha_i) beta_i
  a.dont_use_noisy_pts=0;
  a.reoptimize=1;    
  a.reoptimize_b=1;
  a.optimizer='andre';
  
  % model 
  a.alpha=[];
  a.Xsv=[];  
  a.b0=0;
  a.w2=0;  % final value of ||w*-w^2||^2, set to -1 to calculate

  
  if nargin==0
    a.child=svm;  
  else 
    a.child=alg; %% algorithm to use  
  end
  
  p=algorithm('rss_l1');
  a= class(a,'rss_l1',p);
  a.algorithm.use_signed_output=0;
  
  if nargin==2
    eval_hyper;
  end  
  
 
