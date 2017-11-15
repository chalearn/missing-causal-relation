
function a = subsample(pidx, hyper) 
%=============================================================================
% SUBSAMPLE object to subsample the training data             
%=============================================================================  
% a=subsample(pidx, hyper)
% a=subsample(hyper)
%
% The effect of training is to restrict the training data to a 
% randomly chosen subsample.
%
%   Hyperparameters:
%   pnum                -- number of patterns selected
%
%   Model
%   pidx                -- indices of the patterns retained
%
% Note that, in place of training, pidx can be set "by hand" and passed as an
% argument.
%
% Methods:
%  train, test, default, get_idx 
%
% Examples: d=data(rand(10,5),[1 1 1 1 -1 -1 -1 -1 -1 -1 ]'); 
%           data_subsample=train(subsample('p_max=5'),d); 
%           my_subsample=subsample('child=[1 3 5]'); get_idx(my_subsample)
%           pidx=[1 3 6 8]; my_subsample=subsample(pidx); get_idx(my_subsample)
%=============================================================================
% Author of code: Isabelle Guyon -- isabelle@clopinet.com -- September 2005
%=============================================================================

a.IamCLOP=1;

% <<------hyperparam initialisation------------->> 
a.display_fields={'p_max', 'balance'};
a.p_max=     default(Inf, [0 Inf]);
a.balance=  default(0, {0, 1});
if nargin==0, pidx=[]; end
if nargin>1,
    a.child=pidx;
else
    a.child=[];
    hyper=pidx;
end

% <<-------------model----------------->> 
a.pidx=[];    

algoType=algorithm('subsample');
a= class(a,'subsample',algoType);

eval_hyper;
 
if ~isempty(a.child), 
    a.pidx=a.child; 
    a.p_max=length(a.pidx);
    a.child=[]; % We cannot distroy that field; we just delete it.
end

 
 





