function [dat, alg] =  training(alg,dat)
%[dat, alg] =  training(alg,dat)
% Compute the odds ratio statistic
% and rank the features accordingly.
% Returns the training data matrix dat restricted to the
% selected features (i.e. feat_num<=feat_max and w>w_min.

% Isabelle Guyon -- isabelle@clopinet.com -- October 2007
  
if alg.algorithm.verbosity>0
    disp(['training ' get_name(alg) '... '])
end
 
[p,n]=get_dim(dat);

X=get_x(dat);
Y=get_y(dat);


Xbin=X;
Ydefault=sign(mean(Y));
if Ydefault==0, Ydefault=1; end
for j=1:n
    % Test whether the features is binary
    is_binary=0;
    if length(unique(X(:,j)))==2
        is_binary=1;
    end
    if ~is_binary, % univariate training
        [d, m]=train(alg.child, data(X(:,j), Y));
        d=test(m, data(X(:,j), Y));
        x=sign(d.X);
        x(find(x==0))=Ydefault;
        r=corrcoef(X(:,j), d.X);
        if r(1,2)<0, x=-x; end % Orient correctly
    else
        x=X(:,j); % turn binary 0/1 to -1/1
        x(find(x==0))=-1;
    end
    Xbin(:,j)=x;
end
X=Xbin;
clear Xbin;
    
Posidx=find(Y>0);
Negidx=find(Y<0);
tp=sum((X(Posidx,:)+1)/2);
tn=sum((-X(Negidx,:)+1)/2);
fn=sum((-X(Posidx,:)+1)/2);
fp=sum((X(Negidx,:)+1)/2);

% Adjusted odds ratio (Hollander and Wolfe p. 478)
if alg.adjust
    alg.OR=(tp+0.5).*(tn+0.5) ./ ((fp+0.5).*(fn+0.5));
else
    alg.OR=tp.*tn ./ (fp.*fn);
end

% Standard deviation of the log of the adjusted odds-ratio
if alg.adjust
    SlnOR=sqrt(1./(tp+0.5)+ 1./(tn+0.5)+ 1./(fp+0.5)+ 1./(fn+0.5));
else % adjust only if needed
    SlnOR=sqrt(1./tp + 1./tn + 1./fp + 1./fn);
end

% The z statistic (approximate)
alg.W=abs(log(alg.OR));
Zstat=real(alg.W./SlnOR);

[ss,alg.fidx]=sort(-Zstat);
alg.pval = 2*cdf('norm', -Zstat, 0, 1); % One tailed test; The maximum pvalue will be 0.5
                                        % Multiply by 2 to get pval=1 for a zero weight
sorted_fdr=alg.pval(alg.fidx).*(n./[1:n]);
alg.fdr(alg.fidx) = sorted_fdr;
  
if ~alg.algorithm.do_not_evaluate_training_error
    dat=test(alg, dat);
end

  

  

  
  
