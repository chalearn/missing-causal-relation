function [dat, alg] =  training(alg,dat)
%[dat, alg] =  training(alg,dat)
% Compute the TP statistic
% and rank the features accordingly.
% Returns the training data matrix dat restricted to the
% selected features (i.e. feat_num<=feat_max and w>w_min.

% Isabelle Guyon -- isabelle@clopinet.com -- December 2005
  
if alg.algorithm.verbosity>0
    disp(['training ' get_name(alg) '... '])
end
 
[p,n]=get_dim(dat);

X=get_x(dat);
Y=get_y(dat);

is_binary=0;
if issparse(X) & length(unique(X))==2
    is_binary=1;
    maxx=max(max(X));
    X(find(X==maxx))=1;
end

Posidx=find(Y>0);
Negidx=find(Y<=0);
npos=length(Posidx);
nneg=length(Negidx);
if is_binary
    tp=sum(X(Posidx,:),1);
    fn=npos-tp;
    fp=sum(X(Negidx,:),1);
    tn=nneg-fp;
else
    tp=sum(X(Posidx,:)>0,1);
    tn=sum(X(Negidx,:)<=0,1);
    fn=sum(X(Posidx,:)<=0,1);
    fp=sum(X(Negidx,:)>0,1);
end

alg.W=tp;
[WS, alg.fidx]=sort(-alg.W);
  
if ~alg.algorithm.do_not_evaluate_training_error
    dat=test(alg, dat);
end

  

  

  
  
