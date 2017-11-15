function dat  =  testing(algo,dat)
%dat =  testing(algo,dat)
% Preprocess with equalize.
% Inputs:
% algo -- A "equalize" object.
% dat -- A test data object.
% Returns:
% dat -- Preprocessed data.

% Isabelle Guyon -- Oct 2012 -- isabelle@clopinet.com

X=get_x(dat); 
XX=zeros(size(X));

for k=1:size(X,2)
    XX(:,k)=algo.W(k)*X(:,k)+algo.b(k);
end

dat=set_x(dat, XX);

dat=set_name(dat,[get_name(dat) ' -> ' get_name(algo)]); 
  

 