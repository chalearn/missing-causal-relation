function [r,a] =  training(a,d)

% Isabelle Guyon, isabelle@clopinet.com , Feb. 2009

if a.algorithm.verbosity>0
    disp(['training ' get_name(a) '.... '])
end

Y=get_y(d);
X=get_x(d);
p=size(X,1);

if isempty(a.p_max)
    % Perform regular training
    [r,a.child]=train(a.child, d);
    return
end

set_size=min(a.p_max, p);

% Randomly permute the examples and select an initial set

if a.balance 
    apidx=find(Y>0);
    anidx=find(Y<0);
    rpidx=randperm(length(apidx));
    rnidx=randperm(length(anidx));
    apidx=apidx(rpidx);
    anidx=anidx(rnidx);
    pnum=min(round(set_size/2), length(apidx));
    nnum=min(set_size-pnum, length(anidx));
    active_idx=[apidx(1:pnum); anidx(1:nnum)];
    ridx=randperm(length(active_idx));
    active_idx=active_idx(ridx);
else    
    ridx=randperm(p);
    active_idx=ridx(1:set_size);
end

fprintf('Active set size: %d\n', set_size);
A=[];
for k=1:a.maxiter
    [output, a.child]=train(a.child, data(X(active_idx,:), Y(active_idx)));
    toutput=test(a.child, d);
    A(k)=auc(toutput);
    fprintf('Iteration %d: auctrain = %5.4f\n', k, A(k));
    % Keep the examples in the margin and replace the remainder
    if a.balance
        pidx=find(output.Y==1);
        nidx=find(output.Y==-1);
        good_pidx=find(abs(output.X(pidx,1).*output.Y(pidx,1))<=a.theta);
        good_nidx=find(abs(output.X(nidx,1).*output.Y(nidx,1))<=a.theta);
        good_pidx=pidx(good_pidx);
        good_nidx=nidx(good_nidx);
        if length(good_nidx)>length(good_pidx)
            good_nidx=good_nidx(1:length(good_pidx));
        end
        good_idx=[good_nidx;good_pidx];
        cnum=set_size-length(good_idx);
        if cnum==0; 
            fprintf('Stopping: no more space in active set\n');
            break; 
        end
        fprintf('Replacing %d patterns in active set\n', cnum);
        new_pidx=setdiff(apidx, active_idx(good_pidx));
        new_nidx=setdiff(anidx, active_idx);
        if 1==2
        if ~isempty(new_pidx)
            [s,i]=sort(toutput.X(new_pidx,1).*toutput.Y(new_pidx,1));
            new_pidx=new_pidx(i);
        end
        if ~isempty(new_nidx)
            [s,i]=sort(toutput.X(new_nidx,1).*toutput.Y(new_nidx,1));
            new_nidx=new_nidx(i);
        end
        end
        i=randperm(length(new_pidx)); new_pidx=new_pidx(i);
        i=randperm(length(new_nidx)); new_nidx=new_nidx(i);
        pnum=min(round(cnum/2), length(new_pidx));
        nnum=min(cnum-pnum, length(new_nidx));
        
        new_idx=[new_pidx(1:pnum); new_nidx(1:nnum)];
        active_idx=[active_idx(good_idx); new_idx(1:cnum)];
        active_idx=active_idx(randperm(length(active_idx)));
    else
        good_idx=find(abs(output.X.*output.Y)<=a.theta);
        cnum=set_size-length(good_idx);
        if cnum==0; 
            fprintf('Stopping: no more space in active set\n');
            break; 
        end
        fprintf('Replacing %d patterns in active set\n', cnum);
        new_idx=setdiff(1:p, active_idx);
        new_idx=new_idx(randperm(length(new_idx)));
        active_idx=[active_idx(good_idx'), new_idx(1:cnum)];
        active_idx=active_idx(randperm(length(active_idx)));
    end
end

r   = test(a,d);


