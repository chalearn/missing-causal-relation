function dat =  testing(alg,dat)
% Selects the features using the ranking and the thresholds.
% Returns the test data matrix dat restricted to the
% selected features (i.e. rank<=feat_max and w>w_min.)

% Isabelle Guyon -- isabelle@clopinet.com -- September 2005
    
X=get_x(dat);
X=X(:,alg.fidx);
dat=set_x(dat, X);
dat=set_name(dat,[get_name(dat) ' -> ' get_name(alg)]);
  
 
 
   
 
