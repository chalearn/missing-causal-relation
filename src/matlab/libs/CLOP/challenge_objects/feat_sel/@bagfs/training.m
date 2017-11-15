function [dat, alg] =  training(alg,dat)
%[dat, alg] =  training(alg,dat)
% Compute the ranking criterion for the data 
% using bagging of feature selection
% Returns the training data matrix dat restricted to the
% selected features (i.e. feat_num<=feat_max and w>w_min.

% Isabelle Guyon -- isabelle@clopinet.com -- February 2009
  
if alg.algorithm.verbosity>0
    disp(['training ' get_name(alg) '... '])
end

[p,n]=get_dim(dat);
X=get_x(dat);
Y=get_y(dat);

% Remove limits on the number of features 
alg.child.f_max=Inf;
alg.child.w_min=-Inf;

% compute ranking
sample_num=round(alg.frac_sub*p);
R=zeros(alg.child_num, n); % Matrix of all ranks
for k=1:alg.child_num
    pp=randperm(p);
    pp=pp(1:sample_num);
    [dt, alg.child]=train(alg.child, data(X(pp,:),Y(pp)));
    clear dt
    fidx=get_fidx(alg.child); 
    R(k, fidx)=1:n;
end

muR=mean(R);
[ss,alg.fidx]=sort(muR);
alg.W=-muR; 


if ~alg.algorithm.do_not_evaluate_training_error
    dat=test(alg, dat);
end  

  

  
  
