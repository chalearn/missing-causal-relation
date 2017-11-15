function [d,a] =  training(a,d)
%[d,a] =  training(a,d)
% Ensemble training.

% Isabelle Guyon -- isabelle@clopinet.com -- October 2005/June 2010

% Train all the individual models
r=[]; 
for i=1:length(a.child)
    [dd,a.child{i}]=train(a.child{i},d); 
    dd=test(a.child{i},d);
    r(:,i)=get_x(dd);
end

if 1==2
    nl=0;
    if nl
        % add products of features
        rl=r;
        for i=1:size(rl,2)
            for j=i+1:size(rl,2)
                r=[r rl(:,i).*rl(:,j)];
            end
        end
    end
end

% Optionally take the sign
if a.signed_output
    r=sign(r);
end

if ~isempty(a.out_model)
    % Train the output model
    ddd=data(r, get_y(d));
    [dddd, a.out_model]=train(a.out_model, ddd);
else
    n=length(a.child);
    % Set the voting weights to one and the bias to zero, unless they already exist
    if isempty(a.W)
        a.W=ones(1,n);
    end
    if isempty(a.b0)
        a.b0=0;
    end
end

if a.algorithm.do_not_evaluate_training_error
    d=set_x(d,get_y(d)); 
else
    d=test(a,d);
end






