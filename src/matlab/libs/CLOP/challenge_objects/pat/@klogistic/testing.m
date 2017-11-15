function dat  =  testing(algo,dat)
%dat =  testing(algo,dat)
% Test a klogistic classifier.
% Inputs:
% algo -- A klogistic object.
% dat -- A test data object.
% Returns:
% dat -- The same data structure, but X is replaced by the class label
% predictions on test data.

% Isabelle Guyon -- April 2008 -- isabelle@clopinet.com

if strcmp(algo.optimizer, 'matlab') || strcmp(algo.optimizer, 'liblinear')

    b=zeros(size(dat.X,2)+1,1);
    b(1)=algo.b0;
    b(2:length(b))=algo.W;

    Output = glmval(b, dat.X,'logit');
 
else % 'gkm' 
 
    Output = fwd(algo.gkm, dat.X);

end

% Convert back in the +-1 range
if algo.input_type==1
    Output=2*Output-1;
end

dat=data(Output, dat.Y);

if algo.algorithm.use_signed_output
    dat=set_x(dat, sign(get_x(dat)));
end
 
dat=set_name(dat,[get_name(dat) ' -> ' get_name(algo)]); 
  

 