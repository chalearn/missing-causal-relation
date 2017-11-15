function [w, idx, XR, mse, pval, idx2] = gram_schmidt(X, Y, Numr, itnum, logfile, seed_idx, method,pvalmax,K)
%[w, idx, XR, mse, pval, idx2] = gram_schmidt(X, Y, Numr, itnum, logfile, seed_idx, method,pvalmax,K)
% Gram Schmidt orthogonalization.
% Inputs:
% X         --      Data matrix of dim (p, n), p patterns, n features.
% Y         --      Target vertor (p,1).
% Numr      --      Number of random probes.
% itnum     --      Maximum number of features.
% logfile   --      Log file name.
% seed_idx  --      Index of the first selected feature (optional).
% method    --      Method used to select features (e.g. 'fisher' or 'relief').
% pvalmax   --      Maximum p value.
% K         --      number for neighbors for relief.
%
% Outputs:
% w         --      Weights of the residuals of the features (first is best feature weight)
%                   Note, these are not the weights of the features.
% idx       --      order indices
% XR        --      Matrix of the intermediate residuals solving XR*w'=Y in the least square sense
% mse       --      Intermediate mean square error
% pval      --      corresponding estimated fraction of bad features in the top selected features above

% Isabelle Guyon        -- October 2002         -- isabelle@clopinet.com

% October 2003 change: pval in now nrand/Numr, not (nrand*N)/(Numr*k).
% Does not work for sparse matrices

% Initializations
[p, N]=size(X);
X=full(X);

if ( nargin<3 | isempty(Numr)) & nargout>4, 
    Numr=N;
else
    Numr=1;
end
if nargin<4 | isempty(itnum), itnum=min(p,N); end
if nargin<5 | isempty(logfile), logfile=2; end
if nargin<6, seed_idx=[]; end
if nargin<7 | isempty(method), method='fisher'; end
if nargin<8 | isempty(pvalmax), pvalmax=1; end
if nargin<9 | isempty(K), K=4; end
if Numr==0; Numr=1; end
% Multiclass case?
cl=unique(Y);
cl_num=length(cl);
if (min(cl)==0 & max(cl)==cl_num-1)
    multiclass=1; 
else
    multiclass=0;
end

if multiclass 
    cl_idx=cell(cl_num,1);
    for k=0:cl_num-1
        cl_idx{k+1}=find(Y==k);
    end
end   
    
% Dimension a few arrays
idx=zeros(1,itnum);
w=zeros(1,itnum);
rss=zeros(1,itnum);                         % Residual sum of squares
XR=zeros(p,itnum);                          % Residual vectors of X projections
X_rand=rand_feat(X,Numr);                   % Matrix of probes
pval=zeros(1,itnum);                        % Estimated fraction of bad features above rank of feature
old_pval=0;

colid=1:N;                                  % Original feature numbering
n=N;
numr=Numr;
old_nrand=0;
% Main loop over features
for k=1:itnum
    if logfile, fprintf(logfile, '\nTraining on feature set size: %d\n', N-n+1); end
    % Normalize
    XN=sqrt(sum(X.^2));                      % The norms of the feature vectors
    XN(XN==0)=eps;
    X_norma = X./repmat(XN, p,1);            % The normalized feature matrix
    XN_rand=sqrt(sum(X_rand.^2));            % same for the random vectors
    XN_rand(XN_rand==0)=eps;
    X_rand_norma = X_rand./repmat(XN_rand, p,1);
    if multiclass
        % Compute between-class variance in lieu of y_proj
        mu_val=zeros(cl_num, n);                % Initialize the mean class values
        mu_val_rand=zeros(cl_num, numr);        % Initialize the mean class values
        for kk=1:cl_num
            mu_val(kk, :)=mean(X_norma(cl_idx{kk},:));
            mu_val_rand(kk, :)=mean(X_rand_norma(cl_idx{kk},:));
        end
        y_proj = var(mu_val, 1); % A vector of N dimensions
        y_proj_rand = var(mu_val_rand, 1); % A vector of Numr dimensions
    elseif strcmp(method, 'relief')
        if k==1
            [idxs, y_proj, D] = relief(X_norma, Y, [], K, [], 1);
            [idxs, y_proj_rand, D_rand] = relief(X_rand_norma, Y, [], K, [], 1);
        else
            [idxs, y_proj, D] = relief(X_norma, Y, [], K, [], 1, D);
            [idxs, y_proj_rand, D_rand] = relief(X_rand_norma, Y, [], K, [], 1, D_rand);
        end
    else
        % Project onto Y
        y_proj = sum(repmat(Y, 1, n).*X_norma);  % The signed projection of Y onto all feature vectors
        y_proj_rand = sum(repmat(Y, 1, numr).*X_rand_norma); % Same for the random vectors
    end
    
    ay_proj=abs(y_proj);
    % Bypass the result:
    if k==1 & ~isempty(seed_idx)
        maxidx=seed_idx;
        maxval=ay_proj(seed_idx);
        idx(k)=seed_idx;
        [maxval2, maxidx2] = max(ay_proj);    % Identification of the direction of maximum projection 
        idx2(k)=colid(maxidx2);                   % Identification of the index of that feature in the original numbering
    else
    % Find the direction of maximum projection 
        [maxval, maxidx] = max(ay_proj);    % Identification of the direction of maximum projection 
        idx(k)=colid(maxidx);               % Identification of the index of that feature in the original numbering
        [vp,vi]=sort(-ay_proj);
        if length(vi)>1
            idx2(k)=colid(vi(2));
        else
            idx2(k)=idx(k);
        end
    end
    
    % Find the random probes above the threshold
    rand_idx=find(abs(y_proj_rand)>=maxval);% Find the probes that are caught
    ncaught=length(rand_idx);               % Count them
    nrand=old_nrand+ncaught;                % Cumulate
    old_nrand=nrand;
    %pval(k)=min(1,max(old_pval, (nrand*N)/(Numr*k)));    % Compute pvalue
    pval(k)=min(1,max(old_pval, nrand/Numr));    % Compute pvalue
    old_pval=pval(k);
    X_rand = X_rand(:,setdiff(1:numr, rand_idx)); % Remove them
    numr=numr-ncaught;
    
    % Update the model
    if multiclass | strcmp(method, 'relief')
        w(k)=maxval;
    else
        w(k)=y_proj(maxidx)/XN(maxidx);          % Computation of the weight of that feature for the projected x
        Y_proj = w(k)*X(:,maxidx);               % The projection of Y onto the direction of X(:,maxidx)
        Y_residual = Y - Y_proj;                 % New residual
        rss(k) = sum(Y_residual.^2);             % Residual error of the model at this stage
    end
    
    % Compute the residual X vectors
    X_proj = sum(repmat(X_norma(:,maxidx),1,n).*X);  % Projection of all X onto the chosen direction
    X_residual = X - repmat(X_proj, p, 1).*repmat(X_norma(:,maxidx), 1, n); 
    X_proj_rand = sum(repmat(X_norma(:,maxidx),1,numr).*X_rand);  % Projection of all X_rand onto the chosen direction
    X_residual_rand = X_rand - repmat(X_proj_rand, p, 1).*repmat(X_norma(:,maxidx), 1, numr); 
    % Change the matrices to iterate
    if ~multiclass & ~strcmp(method, 'relief'), Y=Y_residual; end
    XR(:,k)=X(:, maxidx);
    X=X_residual(:, [1:maxidx-1,maxidx+1:n]);
    colid=colid([1:maxidx-1,maxidx+1:n]);
    X_rand=X_residual_rand;
    n=n-1;
   
    if logfile, 
        fprintf(logfile, 'Training mse: %5.2f\n', rss(k)/p);
        fprintf(logfile,'Features selected:\nidx=[');
        fprintf(logfile,'%d ',idx(1:k));
        fprintf(logfile,']\n');  
        fprintf(logfile,'Second best choice:\nidx=[');
        fprintf(logfile,'%d ',idx2(1:k));
        fprintf(logfile,']\n'); 
        fprintf(logfile, 'pvalue: %5.3f\n', pval(k));
    end
    if pval(k)>pvalmax, break; end
end
mse = rss/p;

rng=1:k;
w=w(rng);
idx=idx(rng);
XR=XR(:, rng);
mse=mse(rng);
idx2=idx2(rng);




    