function dat  =  testing(algo,dat)
%dat =  testing(algo,dat)
% Compute the PC features using the eigenvectors computed by training.
% Inputs:
% algo -- A "pc_extract" object.
% dat -- A test data object.
% Returns:
% dat -- Preprocessed data.

% Isabelle Guyon -- September 2005 -- isabelle@clopinet.com

if isempty(algo.U) return; end

X=get_x(dat); 
[p,n]=size(X);

% Center the data
X=full(X)-algo.mu(ones(p,1),:);

% Limit the number of components
pc=size(algo.U,2);
algo.f_max=min(algo.f_max, pc); 
pc=algo.f_max;

% Compute the new features
X=X*algo.U(:,1:pc);

dat=set_x(dat, X);
dat=set_name(dat,[get_name(dat) ' -> ' get_name(algo)]); 
  

 