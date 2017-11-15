
function a = mksvm(kdict,hyper) 
%=============================================================================
% Multi-Kernel LP-SVM following Weston (PhD-thesis, chapter 6)
%=============================================================================
%  
% a=mksvm(kdict,hyperParam) 
%
% Generates a svm object with given hyperparameters.
%
%
%   Hyperparameters (with defaults)
%   kdict={}   		  -- dictionary of kernels (a cell array of kernel objects)
%   C=Inf                -- the soft margin C parameter
%   ridge=1e-13          -- a ridge on the kernel
%   balanced_ridge=0     -- for unbalanced data
%  
%   Model
%    alpha               -- the weights
%    b0                  -- the threshold
%    Xsv                 -- the Support Vectors
%
% Methods:
%  train, test, get_w 
% 
% Example:
% use dictionary of 3 kernels
% [r a]=train(mksvm({kernel,kernel,kernel('rbf',2.5),kernel('rbf',2)}),toy)
% loss(test(a,toy))
%=============================================================================
% Reference : Extensions to the Support Vector Approach, Chapter 6
% Author    : Jason Weston
% Link      : http://www.kyb.tuebingen.mpg.de/bs/people/weston/index.html
%=============================================================================

  %<<------hyperparam initialisation------------->> 
  a.child=kdict;  
  a.C=Inf;
  a.ridge=1e-13;  
  a.balanced_ridge=0;  
  
  
  % <<-------------model----------------->> 
  a.alpha=[];
  a.b0=0;
  a.Xsv=[];
  
  algoType=algorithm('mksvm');
  a= class(a,'mksvm',algoType);

  a.algorithm.alias={'kern','child'}; % kernel aliases
  
 if nargin==2,
    eval_hyper;
 end;





