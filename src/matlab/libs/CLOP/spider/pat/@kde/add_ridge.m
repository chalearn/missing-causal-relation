function [K] =  add_ridge(K,al,d)

  
  %% add ridge
  if al.ridge>0
    K=K+sparse(eye(size(K))*al.ridge);
  end
    
  %% add balanced ridge
  if al.balanced_ridge>0
    % could calc median of diagonal 1,2 // forget about this for the
    % moment because difficult to implement in svmlight 
    % divide by no. of examples in each
 
    Y=get_y(d); l=length(Y);
    
    r=diag(K);

%    COULD TAKE MEDIANS
%    f=find(Y==1); r(f)=r(f)*0+median(r(f))*(length(f)/l)*al.balanced_ridge;
%    f=find(Y==-1); r(f)=r(f)*0+median(r(f))*(length(f)/l)*al.balanced_ridge;
%    OR DO BELOW INSTEAD
    f=find(Y==1); r(f)=r(f)*0+(length(f)/l)*al.balanced_ridge;
    f=find(Y==-1); r(f)=r(f)*0+(length(f)/l)*al.balanced_ridge;

    K=K+diag(r);
         
  end
 





