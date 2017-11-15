function dat  =  testing(algo,dat)
%dat =  testing(algo,dat)
% Compute the PC features using the eigenvectors computed by training.
% Inputs:
% algo -- A "pc_extract" object.
% dat -- A test data object.
% Returns:
% dat -- Preprocessed data.

% Isabelle Guyon -- February 2009 -- isabelle@clopinet.com

X=get_x(dat);
Y=get_y(dat);
[p,n]=size(X);

NX=zeros(p, n*(n-1)/2);

k=0;
for i=1:n
    for j=i+1:n
        k=k+1;
        NX(:,k)=X(:,i).*X(:,j);
    end
end

dat=data([X,NX], Y);

dat=set_name(dat,[get_name(dat) ' -> ' get_name(algo)]); 
  

 