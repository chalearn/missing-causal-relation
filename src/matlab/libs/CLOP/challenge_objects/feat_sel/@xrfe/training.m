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
    Xtrain=get_x(dat);
    Y=get_y(dat);
    
    % Split the data if necessary
    if alg.balance==1
        fprintf('xrfe training in a balanced way\n');
        fn=floor(nn/2);
        % The top ranking features
        IDX{1}=1:fn;
        % The bottom ranking features
        if fn==nn/2
            IDX{2}=nn-fn+1:nn;
        else
            IDX{2}=nn-fn+2:nn;
        end 
        IDX{3}=[];
    elseif alg.balance>1
        fn=round(nn/4);
        if fn~=nn/4
            error('The number of features is not a multiple of 4');
        end
        % The top ranking features
        IDX{1}=1:fn;
        % The bottom ranking features
        IDX{2}=nn-fn+1:nn;
        % The middle features (calibrants)
        IDX{3}=fn+1:3*fn;
    else
        IDX{1}=1:nn;
        IDX{2}=[];
        IDX{3}=[];
    end
    
    for kl=1:3
        WW{kl}=[];
    end
    
    % Loop over underexpressd and overexpressed genes
    % idx: temporary feature subset
    % scs: scores
    % idxs: indices
    for kexp=1:length(IDX)
        
        if isempty(IDX{kexp}), continue; end
        
        if kexp==3
            top_chosen=IDX{1};
            bottom_chosen=IDX{2};
            idx=[top_chosen(1:alg.f_max/4), IDX{3}, bottom_chosen(end-alg.f_max/4+1:end)]; % Previously selected features and calibrants
        else
            idx=IDX{kexp};                % Informative features
        end
        idxs=idx;                         % Sorted informative features
        scs=ones(size(idxs));             % Feature scores
        ll=length(idxs);
        if div2
           N=ceil(log(ll)/log(2));
        else
           N=ll;
        end
    
        for kk=N-1:-1:0 % Loop over set size reduction 
            if logfile>0
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
            if div2 & (n>=2) && logfile>0
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
            ii=n-red_step+1:n; % extract the last red_step feat (the best)
            idx =idx(widx(ii));
        end %for kk, loop over set sizes
        
        % Reverse feature order for the positive features
        if kexp~=2
            IDX{kexp}=idxs(ll:-1:1);
            WW{kexp}=scs(ll:-1:1);
        elseif kexp==2
            IDX{kexp}=idxs;
            WW{kexp}=scs;
        end
    end % for kexp
    if alg.balance<2
        idx=[IDX{1}, IDX{2}];
        W=[WW{1}, WW{2}];
    elseif alg.balance==2
        idx=IDX{3};
        W=WW{3};
    else
        midf=floor(nn/2);
        fm=alg.f_max/4;
        i1=IDX{1};
        w1=WW{1};
        i2=IDX{2};
        w2=WW{2};
        %i3=fn+1:fn+2*fm;
        i3=midf-fm+1:midf+fm;
        idx=[i1(1:fm), i3, i2(end-fm+1:end)];
        W=[w1(1:fm), zeros(1, length(i3)), w2(end-fm+1:end)];
    end
    
    % Cache results
    if ~isempty(alg.cache_file)
        save(alg.cache_file, 'idx', 'W');
    end

end

alg.fidx=idx;
alg.W=[];
alg.W(alg.fidx)=W; % Reorder the weights properly!
  
dat=test(alg, dat);



  

  
  
