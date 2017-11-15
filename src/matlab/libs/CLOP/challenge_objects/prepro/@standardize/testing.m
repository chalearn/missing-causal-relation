function dat  =  testing(algo,dat)
%dat =  testing(algo,dat)
% Preprocess with standardization parameters.
% Inputs:
% algo -- A "standard" object.
% dat -- A test data object.
% Returns:
% dat -- Preprocessed data.

% Isabelle Guyon -- September 2005 -- isabelle@clopinet.com

if isempty(algo.mu) return; end

X=get_x(dat); 
[p,n]=size(X);

if ~isempty(X)
    X=(X-algo.mu(ones(p,1),:))./algo.sigma(ones(p,1),:);
end

dat=set_x(dat, X);

dat=set_name(dat,[get_name(dat) ' -> ' get_name(algo)]); 
  

 