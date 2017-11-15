
function a = loocv(algo,hyper) 

%=====================================================================================
%  Leave-one-out cross validation object      
%=====================================================================================   
%  a=loocv(algo,hyperParam) Returns a cv object on algorithm algo using with 
%                        given Hyperparameters. 
% 
%
%  Model:
%   child                 - stored in child algorithm 
%
%  Methods:
%   train                 - selfexplanatory
%   test                  - selfexplanatory
  
  % <<---- Initialisation of Hyperparams ---->>

  % <<---- Initialisation of model ---->>
  if nargin>0
   a.child=algo;
  else
   a.child=naive; 
  end
  
  
  p=algorithm('loocv');
  a= class(a,'loocv',p);
  if nargin==2,
    eval_hyper;
  end;
  

   
