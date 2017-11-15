function [r,a] =  training(a,d)

% Isabelle Guyon, isabelle@clopinet.com , Sept. 2006

if a.algorithm.verbosity>0
    disp(['training ' get_name(a) '.... '])
end

Y=get_y(d);
X=get_x(d);
featnum=size(X,2);

% Find "negative features" (all negative for the positive class, with ber_max tolerance)
pidx=find(Y>0);
bin_feat=find(all(abs(2*X-1)==1));
a.negfeat=bin_feat(find(mean(X(pidx,bin_feat))<=a.tol));
a.posfeat=setdiff(1:featnum, a.negfeat);

% Remove the pattern of negative class with at least one positive negfeat
nidx=find(Y<0);
gnidx=nidx(find(sum(X(nidx, a.negfeat),2)==0));
bnidx=nidx(find(sum(X(nidx, a.negfeat),2)~=0));

% Inject some more negative examples eventually
if isempty(a.p_min), a.p_min=length(Y); end
bnum=max(0, a.p_min-length(pidx)-length(gnidx));

pat_idx=[pidx;[gnidx; bnidx(1:bnum)]];
Xtr=X(pat_idx, a.posfeat);
size(Xtr)
Ytr=Y(pat_idx);

% Shuffle data
rndidx=randperm(length(Ytr));
Xtr=Xtr(rndidx,:);
Ytr=Ytr(rndidx);

[posres, a.child]=train(a.child, data(Xtr, Ytr));

if ~a.algorithm.do_not_evaluate_training_error
    r   = test(a,d);
else
    r   = set_x(r,get_y(r));
end

