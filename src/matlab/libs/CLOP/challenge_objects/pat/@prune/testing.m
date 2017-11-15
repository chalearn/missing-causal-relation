function d =  testing(a,d)

% Isabelle Guyon, isabelle@clopinet.com , Sept. 2006

X=get_x(d);
Y=get_y(d);
r=zeros(size(X,1),1);

% Use the classifier to classify the examples with negative negfeat

kept_pat = find(sum(X(:, a.negfeat),2)==0);
if ~isempty(Y)
    kept_res = test(a.child, data(X(kept_pat,a.posfeat), Y(kept_pat)));
else
    kept_res = test(a.child, data(X(kept_pat,a.posfeat)));
end
r(kept_pat)=kept_res.X;

% Classify the examples with positive (non-zero) negfeat in the negative class

pruned_pat = find(sum(X(:, a.negfeat),2)~=0);
r(pruned_pat)=-max(abs(r))-1; % A small value
if ~isempty(Y)
    fprintf('Pruned pattern error rate = %5.2f\n', length(find(Y(pruned_pat)~=-1))/length(pruned_pat));
end

if a.algorithm.use_signed_output
    r   = sign(r);
end

d   = set_x(d,r);
d   = set_name(d,[get_name(d) ' -> ' get_name(a)]);

