function a = mc_svm(hyper) 

%=========================================================================  
% Multi-class Support Vector Machine by J.Weston
%========================================================================= 
% A=MC_SVM(H) returns an mc_svm object initialized with hyperparameters H. 
%
%  Multi-class Support Vector Machine, solving a single
%  optimization problem.
%
% Hyperparameters, and their defaults
%  C=Inf                -- the soft margin C parameter
%  child=kernel         -- the kernel is stored as a member called "child"
% 
% Model
%  alpha                -- the weights
%  b0                   -- the threshold
%  Xsv                  -- the Support Vectors
%
% Methods:
%  train, test, get_w  
%
% Example:
% 
% c1=[-1,1];c2=[1,1];c3=[0,-1];
% 
% X1= randn(50,2)+repmat(c1,50,1);
% X2= randn(50,2)+repmat(c2,50,1);
% X3= randn(50,2)+repmat(c3,50,1);
% % note the class label format!
% Y1= [ones(50,1),-ones(50,1),-ones(50,1)];
% Y2= [-ones(50,1),ones(50,1),-ones(50,1)];
% Y3= [-ones(50,1),-ones(50,1),ones(50,1)];
% 
% d=data([X1;X2;X3],[Y1;Y2;Y3]);
% 
% [r,a]=train(mc_svm(kernel('rbf',2)),d)
% % Test class centers
% dtest=data([c1;c2;c3]);
% rtest=test(a,dtest)
% plot(a);
%=========================================================================
% Reference : Multi-class Support Vector Machines 
% Author    : Jason Weston, Chris Watkins
% Link      : http://citeseer.ist.psu.edu/8884.html
%=========================================================================  
  
  a.C=Inf;
  a.child=kernel;
 
  % model 
  a.alpha=[];
  a.b0=0;
  a.Xsv=[];
  
  p=algorithm('mc_svm');
  a= class(a,'mc_svm',p);
  
 if nargin==1,
   eval_hyper;
 end;
 
