function a = ppca(hyper)   

%====================================================================    
% Probabilistic Principal Components Analysis  
%====================================================================    
% A=PPCA(H) returns a ppca object initialized with hyperparameters H.   
%  
% Hyperparameters, and their defaults  
%  feat=0;              -- number of features, default 0 means all via dim X  
%  iterations=10000     -- number of iterations for the EM algorithm
%
% Model  
%  e_val                -- the eigenvalues  
%  e_vec                -- the eigenvectors 
%  W                    -- the principal components
%  offset               -- the mean of the training data
%  sigma                -- the isotropic noise term sigma^2
%  dat                  -- training data (that we extracted from)  
%  
% Methods:  
%  train, test 
%
% Example:
% d=gen(toy({'l=1000','n=2'}));
% d.X=d.X*[1,0.1;0.2,0.2];
% [r,a]=train(ppca('iterations=5000'),d);
% plot(d.X(:,1),d.X(:,2),'r.');
% hold on;
% line([0,a.e_vec(1,1)],[0,a.e_vec(2,1)])
% line([0,a.e_vec(1,2)],[0,a.e_vec(2,2)])
% axis([-1,1,-1,1])
%====================================================================
% Reference : Probabilistic analysis of kernel principal components : mixture modeling and classification
% Author    : Shaohua Zhou
% Link      : http://www.cfar.umd.edu/~shaohua/papers/zhou04tpami.pdf
%====================================================================
   
  %hyperparams   
  a.feat=0;  
    
  % model   
  a.e_vec=[]; % eigenvectors  
  a.e_val=0;  % eigenvalues  
  a.offset=[];  % offset     
  a.dat=[];  
  a.iterations = 10000;
  a.W  = [];
  a.sigma = 0;
    
  p=algorithm('ppca');  
  a= class(a,'ppca',p);  
   
  
  if nargin==1,  
    eval_hyper;  
  end;  
