function a = nfe(hyper)     
%=========================================================================
% Non-Linear Feature Elimination
%=========================================================================  
% data=nfe
% runs a non-linear feature elimination 
%=========================================================================
% Reference : Feature selection for SVMs
% Author    : J. Weston, S. Mukherjee, O. Chapelle, M. Pontil, T. Poggio, and V. Vapnik
% Link      : http://www.kyb.tuebingen.mpg.de/bs/people/weston/FEATURE_SEL.PS
%=========================================================================
    
  %hyperparams
  a.feat=[];       % number of features 
  a.speed=0;       % rfe only removes a single feature if less than
                   % speed features left 
  a.output_rank=0; % output labels, not selected features 
  a.k=2; % non linearity (degree of the polynomial that is used as non-linearity
    
  % model
  a.rank=[];
  a.child=svm;
  
  p=algorithm('nfe');
  a= class(a,'nfe',p);
  if nargin==2
    eval_hyper;
  end  
       

