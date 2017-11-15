function a = kpls(hyper) 
%=========================================================================  
% Kernel Partial Least Squares by Rosipal et al.
%=========================================================================   
% A=kpls(C) returns a kernel partial least squares  object
%  object initialized with hyperparameters H.  
%	
% 
%  Hyperparameters, and their defaults
%   nroflatent=5;	 maximum number of latent variables. depends also on
%                    epsilon
%   epsilon          stopping criteria - determines number of latent
%                    variables
%   epsilon2         stopping criteria for found directions
%
%  Model
%   a.dtraining=[]; data used for training 
%   a.Kc=[];        centered kernel matrix
%   a.U=[];         found output directions
%   a.T=[];         found input directions
%   child 		 -- kernel 
%   original;     -- 
% 
%  Methods:
%
%   train, test
%=========================================================================
% Reference : Kernel Partial Least Squares Regression in Reproducing Kernel Hilbert Space
% Author    : Roman Rosipal , Leonard J. Trejo
% Link      : http://www.kernel-machines.org/jmlr/
%=========================================================================

  % hyperparams 
  
  a.alpha=[];
  
  a.child=kernel;
  a.epsilon=1e-5;
  a.epsilon2=1e-6;
 
  a.nroflatent=5;
  a.dtraining=[];
  a.Kc=[];

  a.U=[];
  a.T=[];
  
  a.W=[];
  a.C=[];
  

  p=algorithm('kpls');
  a= class(a,'kpls',p);
 
  if nargin==1,
    eval_hyper;
  end;

