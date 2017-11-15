function [d,a] =  training(a,d)

% IG October 2005: we separate training and testing
% because now the children do not evaluate their training error

cn=length(a.child);
if ~a.algorithm.do_not_evaluate_training_error
    for i=1:cn
        if ~isa(a.child{i}, 'zarbi')
            a.child{i}.algorithm.do_not_evaluate_training_error=0;
        end
    end
else
    if ~isa(a.child{cn}, 'zarbi') 
        a.child{cn}.algorithm.do_not_evaluate_training_error=1;
    end
end


for i=1:length(a.child)  
    [d a.child{i}]=train(a.child{i},d);
    if i<length(a.child) & (isa(a.child{i},'group') | isa(a.child{i},'param')) 
        a.child{i}.group='one_for_each'; 
    end
end
