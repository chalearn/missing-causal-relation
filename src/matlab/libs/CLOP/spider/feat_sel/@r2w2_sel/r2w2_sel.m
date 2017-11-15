function a = r2w2_sel(hyper) 
%=========================================================================    
%  Feature scaling/selection via SVMs and r^2/w^2 bound.
%=========================================================================   
%  A=R2W2_SEL(H) returns an r2w2_sel object with hyperparameters H. 
% 
%  Hyperparameters, and their defaults
%   feat=[]              -- number of features, (default means
%                           use scaling factors instead)
%   output_rank=0        -- output rank (if 0, output predicted labels)
%   slacks=0;            -- if slacks=1,optimize ridge as well, 
%                           if this is a vector it specifies
%                           which examples share slacks (e.g 3 examples,
%                           slacks=[1 1 2] means first two examples
%                           have a shared slack variable)
%   scales=1;            -- if scales=1, find scaling factors, if 0
%                           do not, if scale is a vector, specifies
%                           sharing of scaling factors as in slacks parameter
%   max_iter=100         -- maximum number of gradient steps 
%   steep_ascent=0       -- use steepest grad ascent (can be faster when
%                           there are many features) 
%   use_var2=1           -- use var^2w^2 estimate instead of r^2w^2
%   ker='weighted_linear'-- type of kernel, other choices='weighted_poly'
%                           or 'weighted_rbf' 
%   kerparam             -- associated param, e.g degree of poly
%   optimizer='default'  -- choices={default,andre,quadprog,svmlight}
%
%  Model
%   rank                 -- ranking of the features
%   child                -- decision rule stored in child member (svm)
%   sigma                -- value of all scaling and slacking factors
%
%  Example:
%  d=gen(toy); a=r2w2_sel; a.feat=20; a.output_rank=1;[r,a]=train(a,d);
%  a.rank  % - lists the chosen features in  order of importance, using 20 features
%
%=========================================================================
% Reference : Feature selection for SVMs
% Author    : J. Weston, S. Mukherjee, O. Chapelle, M. Pontil, T. Poggio, and V. Vapnik
% Link      : http://www.kyb.tuebingen.mpg.de/bs/people/weston/FEATURE_SEL.PS
%=========================================================================
  
  %hyperparams
  a.feat=[];        
  a.output_rank=0;  
  a.max_iter=100;  
  a.steep_ascent=0;
  a.optimizer='default'; 
  a.use_var2=1;
  a.scales=1;  
  a.slacks=0;         
  a.ker='weighted_linear';
  a.kerparam=1;
  
  % model            
  a.rank=[];
  a.child=[];
  a.sigma=[];
  
  p=algorithm('r2w2_sel');
  a= class(a,'r2w2_sel',p);
 
  if nargin==1
    eval_hyper;
  end  
  
  

