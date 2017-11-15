
function a = chain(in,hyper)
 
%==================================================================
% CHAIN chain object
%==================================================================
% A=CHAIN(I,H) returns a chain object initialized with 
%  a cell array of algorithms I and (hyper)parameters H.
%   
% This is used to create a chain of algorithms, the output of one
%  is fed into the input of the next.
%
% Examples: f=chain({fisher('output_rank=1;feat=5') knn});
%           [r,a]=train(cv({f knn}),toy);
%           get_mean(r)
%==================================================================
% Reference : 
% Author    : 
% Link      : 
%==================================================================
% IG: modified October 2005: do not evaluate training error of the
% chain members to save time!

  a.IamCLOP=1;
 
  if nargin == 0, in = {}; end
  
  a.child={};
  if ~iscell(in)       
    if ischar(in)
        % The first argument is in fact a hyperparameter string
        hyper=in;
    else
        % The first argument is a single learning object
        a.child{1}=in; 
    end
  else
    % determine whether a hyperparameter array is passed
    hp=0;
    for k=1:length(in)
        if ischar(in{k})
            hp=1;
        end
    end
    if hp
        hyper=in;
    else
        a.child=in; 
    end
  end
  
  p=algorithm('chain');
  a= class(a,'chain',p);
  %a.orig=a.child;  %% original algorithm set given (for retraining)
  
  %hyperparams
  eval_hyper;
  
  % convert {} to group({})
  for i=1:length(a.child) 
     if isa(a.child{i},'cell') a.child{i}=group(a.child{i}); end;
  end
  
  cn=length(a.child);
  if cn>0 & ~isa(a.child{cn}, 'zarbi')
      a.child{cn}.algorithm.do_not_evaluate_training_error=1;
  end
  % Note: not evaluating the training
  % error for a chain makes sense only for the last element
  % of the chain.
