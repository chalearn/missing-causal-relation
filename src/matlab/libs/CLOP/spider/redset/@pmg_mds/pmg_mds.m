function a = pmg_mds(hyper) 
%=================================================================
% Pre-Image Technique using MDS by Kwok et al.
%=================================================================
% a = pmg_mds(alg,hyper)
% generates a pre-image object; uses the MDS Method
% -------------------------------------------------------
% hyperparameters:
% child=kernel     kernel to work with.
% map='rbf_inv'	   function to convert kernel distance back to input distance
% eps=1e-5         epsilon
% n=5         	   number of nearest neigbhors
% kp=kpca		   kpca object
% dn=sample data   data pool, if empty uses kp.dat		
% stats:
% methods:
% train         calls test
% test			find the preimage 
%
% example:
% k=kernel('rbf',1.5);
% 
% d=gen(toy2d);
% d2=gen(toy2d);
% [r,kp]=train(kpca({k,'feat=20'}),d2);
% p0=pmg_mds;
% p0.kp=kp; 
% p0.child=k;
% p0.n=10;
% 
% 
% r=test(kp,d);
% 
% reconstruct=test(p0,r)
% 
% clf;
% hold on;
% plot(d2.X(:,1),d2.X(:,2),'g.');
% plot(d.X(:,1),d.X(:,2),'r.'); 
% plot(reconstruct.X(:,1),reconstruct.X(:,2),'o');
%=============================================================================
% Reference : The Pre-Image Problem in Kernel Methods
% Author    : James Kwok et al.
% Link      : -
%=================================================================


  % hyperparameters
  a.child=kernel;
  a.map = 'rbf_inv';
  a.eps = 1e-5;
  a.n = 5;
  a.kp = [];
  a.dn =[];
  a.rn =[];

  if nargin==0
    a.kp=kpca;  
  end
  
  p = algorithm('pmg_mds');
  a = class(a,'pmg_mds',p);
  
  if nargin==1
    eval_hyper;
  end  