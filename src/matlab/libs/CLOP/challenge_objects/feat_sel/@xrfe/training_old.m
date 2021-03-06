function [dat, alg] =  training(alg,dat)
%[dat, alg] =  training(alg,dat)
% Compute the RFE ranking
% and rank the features accordingly.
% Returns the training data matrix dat restricted to the
% selected features (i.e. feat_num<=feat_max and w>w_min.

% Isabelle Guyon -- isabelle@clopinet.com -- September 2005
  
if alg.algorithm.verbosity>1
    logfile =1;
else
    logfile=0;
end

if ~isempty(alg.cache_file) && (exist(alg.cache_file, 'file') || exist([alg.cache_file '.mat'], 'file'))
    if alg.algorithm.verbosity>0
        fprintf('Loading: %s\n', alg.cache_file);
    end
    load(alg.cache_file);
else
    if alg.algorithm.verbosity>0
        disp(['training ' get_name(alg) '... '])
    end
    div2=alg.div2;

    [pp,nn]=get_dim(dat);
    idx=[1:nn];             % Informative features
    idxs=idx;               % Sorted informative features
    scs=ones(size(idxs));   % Feature scores
    ll=length(idxs);

    % Initializations
    Y=get_y(dat);
    if div2
       N=ceil(log(ll)/log(2));
    else
       N=ll;
    end

    Xtrain=get_x(dat);

    for kk=N-1:-1:0 % Loop over set size reduction 
        if logfile
            if div2
                fprintf(logfile, '\n== Featnum= %d ', length(idx));
            else
                fprintf(logfile, '%d\n', length(idx));
            end
        end
        X=Xtrain(:,idx);
        [p,n]=size(X);

        Output=zeros(p,1);
        errnum=0;

        % Call the training routine
        [ndat, mdl]=train(alg.child, data(X,Y));

        % Get the weight vector
        W=get_w(mdl);
        aw=abs(W);

        % Sort weights in ascending order
        [ws, widx] = sort(aw);
        if div2 & (n>=2)
           fprintf(logfile, ' Bestfeat: \n');
           fprintf(logfile, '%d ', idx(widx(n:-1:max(n-9,1))));
        end

        % Update the rank ordered list idxs and scores
        idxs(ll-n+1:ll)=idx(widx);
        scs(ll-n+1:ll)=ws;
        % Reduce the feature set
        if div2
           red_step=2^kk;
        else
           red_step=kk;
        end
        ig = idx(widx(1:n-red_step));
        idx = idx(widx((n-red_step)+1:n));

    end %for kk, loop over set sizes

    % Reverse feature order
    idx=idxs(ll:-1:1);
    W=scs(ll:-1:1);
    
    % Cache results
    if ~isempty(alg.cache_file)
        save(alg.cache_file, 'idx', 'W');
    end
end

alg.fidx=idx;
alg.W=[];
alg.W(alg.fidx)=W;
  
dat=test(alg, dat);



  

  
  
