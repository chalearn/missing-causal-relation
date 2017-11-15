
function a = template(hyper) 
   
% TEMPLATE template object 
% AUTHOR:  <your name>, <your email>
%  
% A=TEMPLATE(H) returns a template object initialized with hyperparameters H. 
%
%  The template object is a simple linear support vector machine, with
%   soft margin hyperparameter C. Please use this template to
%   implement your own algorithms.
%
% Hyperparameters, and their defaults
%  C=Inf                -- the soft margin C parameter
% 
% Model
%  alpha                -- the weights
%  b0                   -- the threshold
%  Xsv                  -- the Support Vectors
%
% Methods:
%  train, test 
% 
% Example: 
%   [r,a]=train(template,gen(toy))
% ========================================================================
% Refernce  : 
% Author    : 
% Link      : 
% ========================================================================

a.gkm      = klr('Verbosity', 'ethereal');
a.selector = simplex;
  
p=algorithm('spider_klr');
a= class(a,'spider_klr',p);
 
if nargin==1,

   eval_hyper;

end;

