function a = fsv(hyper)

%========================================================================= 
% Primal zero-norm based feature selection by O.Mangasarian
%========================================================================= 
% A=FSV(H) returns a fsv object initialized with hyperparameters H. 
%
% Hyperparameters, and their defaults
%  lambda=1             -- the lambda parameter beteen 0 and 1. 
%                          (1=min. zero norm, 0=min. hinge loss)
%  alpha=5              -- the alpha parameter 
%  feat=[]              -- number of desired features (if empty gives
%`                         the smallest)
%  output_rank=0        -- when set to 1, output features only
%
% Model
%  rank                 -- the rank of the features
%  w                    -- the weight
%  b0                   -- the threshold
%  
% Methods:
%  training, testing 
%
% Example:
% d=gen(toy); a=fsv; a.feat=10; a.output_rank=1;[r,a]=train(a,d);
% a.rank  % - lists the chosen features in  order of importance
% 
%=========================================================================
% Reference : Feature selection via concave minimization and support vector machines
% Author    : Paul S. Bradley and Olvi L. Mangasarian
% Link      : http://portal.acm.org/citation.cfm?id=657467&dl=ACM&coll=GUIDE
%=========================================================================
  % model 
  a.rank=[];
  a.w=[];
  a.b0=0;
  a.feat=[];
  a.output_rank=0; % don't output labels, output selected features 
    
  % parameters
  a.lambda=1;
  a.alpha=5;
  
  p=algorithm('fsv');
  a= class(a,'fsv',p);
    if nargin==1,
     eval_hyper;
  end;  
  
 
