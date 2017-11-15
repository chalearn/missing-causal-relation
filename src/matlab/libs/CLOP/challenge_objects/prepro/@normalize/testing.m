function dat  =  testing(algo,dat)
%dat =  testing(algo,dat)
% Preprocess with line normalization.
% Inputs:
% algo -- A "normalize" object.
% dat -- A test data object.
% Returns:
% dat -- Preprocessed data.

% Isabelle Guyon -- September 2005 -- isabelle@clopinet.com

X=get_x(dat); 
[p,n]=size(X);

if algo.center
    CX=mean(X,2);
    X=X-CX(:,ones(1,n));
end
NX=sqrt(sum(X.^2,2));
NX(find(NX==0))=1;
X=X./NX(:,ones(1,n));

dat=set_x(dat, X);

dat=set_name(dat,[get_name(dat) ' -> ' get_name(algo)]); 
  

 