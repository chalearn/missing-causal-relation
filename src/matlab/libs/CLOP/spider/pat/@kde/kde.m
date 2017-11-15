function a = kde(hyper)   
%===============================================================================      
% Kernel dependency estimation - for general input-output relations  
%===============================================================================     
% This version does an eigendecomposition of the output kernel L     
% and learns targets by learning each orthogonal direction independently.  
% The pre-image algorithm is just to choose closest pre-image from  
% training set.    
%  
% A=KDE(H) returns a kde object initialized with hyperparameters H.   
%  
% Hyperparameters, and their defaults   
%  feat=[]               -- number of KPCA features to train on,  
%                          default take eigenvalues with lambda>lambda_max/10000  
%  ridge=1e-5           -- regularization on input kernel  
%  child=kernel         -- the kernel for inputs stored as member "child"  
%  ok=kernel            -- the kernel for outputs  
%  output_preimage=0    -- output index from training sample of  preimage   
%                          instead of actual label  
%  use_pca=1            -- can remove decorrelation part for quick & dirty
%                          approximation (also allows to handle non-Mercer
%                          kernels)
% Model  
%  alpha                -- the weights   
%  Xsv                  -- the Support Vectors  
%  uv                   -- decomposition in output space  
%  
% Methods:  
%  train, test 
%=============================================================================== 
% Reference  : Kernel Dependency Estimation
% Author     : Jason Weston, Olivier Chapelle, Andre Elisseeff, Bernhard Schoelkopf and Vladimir Vapnik
% Link       : http://www.kyb.tuebingen.mpg.de/bs/people/weston/
%===============================================================================   
   
    
  %hyperparams    
  a.ridge=1e-5;  
  a.output_preimage=0;  
  a.feat=[];  
  a.use_pca=1;

  a.child=kernel;  
  a.ok=kernel; a.ok.calc_on_output=1;  
    
  % model   
  a.alpha=[];  
  a.Xsv=[];  
  a.uv=[];  
  a.kpca = kpca;
  a.kpca.child = a.ok;
  a.lambda_frac = 0.01;
  a.ik = kernel;
  a.do_input_kpca = 0;
  a.kpca_in = kpca;
  p=algorithm('kde'); p.use_signed_output=0;  
  a= class(a,'kde',p);  
  
  if nargin==1,  
    eval_hyper;  
  end;  
