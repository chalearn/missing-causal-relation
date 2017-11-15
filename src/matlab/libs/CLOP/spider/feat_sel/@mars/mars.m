
function a = mars(c,hyper) 

%=========================================================================
% Greedy selection algorithm by J.Friedmann 
%=========================================================================  
% A=MARS(C,H) returns a mars object initialized with hyperparameters H and
%             based on algorithm C. 
%
% Hyperparameters, and their defaults
%
%  M = 20          -- Maximum number of base functions
%  d = 2            -- Trade-off in the GCV to perform model selection
%  C = svm          -- algorithm to be used during the MARS procedure
%                      (attribute A.child)
% Model:
%  B                -- the parameters of the base functions
%  Xsv              -- the dataset used for learning
%  J                -- the set of selected features (backward step of mars)
% 
% Methods:
%  training, testing 
%
% Example:
% [r a]=train(mars(svm('ridge=0.001'),'M=2'),toy2d('l=30'))
%
%=========================================================================
% Reference : Multivariate adaptive regression splines
% Author    : J.H. Friedmann
% Link      : http://citeseer.ist.psu.edu/context/17716/0
%=========================================================================
  
  % model 
  a.M = 20;
  a.d = 2;
  
  a.B=[];
  a.Xsv=[];
  a.J = [];
  
  if nargin==0
    a.child=svm;  
  else 
    a.child=c; %% algorithm to use  
  end
  
  
  p=algorithm('mars');
  a= class(a,'mars',p);
 

  if nargin==2,
    eval_hyper;
  end;
