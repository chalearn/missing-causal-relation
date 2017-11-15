
function a = indep(i1,i2) 

%=========================================================================   
% Feature selection by independent density estimation 
%========================================================================= 
% A=INDEP(C,H) returns a indep object initialized with density
% estimator(s) C and hyperparameters H. 
%
% Training will try to fit the estimator C to each feature independently,
% C can be an array of algorithms, one for each feature.
% Testing will return the density estimate for each data point tested,
% or if passed the empty dataset will generate new 
% class data according to the densities in the model. 
%
% Hyperparameters:
%  l=50            -- number of data points to generate if asked to generate   
%  
% Model:
%  child={gauss}   -- array of underlying density estimators
%
% Methods:
%  train, test, generate
%
% Examples: 
%   gen(indep({gauss([-1]) gauss([1])}))
%   get_mean(train(cv(bayes(indep)),toy))   %% run naive bayes
%=========================================================================
% Reference : 
% Author    : 
% Link      : 
%=========================================================================

  a.l=50;
  a.child=gauss;
  
  p=algorithm('indep');
  a= class(a,'indep',p);
 
  if nargin==1 
    if ischar(i1)
      hyper=i1; eval_hyper; return;
    else
      a.child=i1; 
    end
  end;

  %a.child.verbosity=0;
  
  if nargin==2 
    a.child=i1; 
    hyper=i2; eval_hyper; return;
  end;






