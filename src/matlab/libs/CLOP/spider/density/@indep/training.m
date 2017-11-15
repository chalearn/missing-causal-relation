function [d,a] =  training(a,d)
  
  if a.algorithm.verbosity>0
    disp(['training ' get_name(a) '.... '])
  end
  
  [l n k]=get_dim(d); 
    
  if iscell(a.child)    %% make n copies of child alg, one for each feature
    % do nothing
  else
    r=[]; for i=1:n r{i}=a.child; end;
    a.child=r; 
  end
  
  for i=1:n
    dtmp=get(d,[],i); 
    [r a.child{i}]=train(a.child{i},dtmp);
  end
  
  if ~a.algorithm.do_not_evaluate_training_error
    d=test(a,d);
  end
  
  
