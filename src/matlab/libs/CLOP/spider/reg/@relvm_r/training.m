function [dat,a] =  training(a,dat)

[numEx,vDim,oDim]= get_dim(dat);
disp(['training ' get_name(a) '.... '])


t=get_y(dat);
if(size(t,2)>1)
    a=multi_reg(a);
    [dat,a]=train(a,dat);
    return;
end
PHI = calc(a.child,dat);



[N,M]	= size(PHI);
w	= zeros(M,1);
PHIt	= PHI'*t;


weights=[];

used=[];
marginal=[];
alpha=[];
beta=a.beta0;
gamma=[];


alpha		= ones(M,1);
gamma		= ones(M,1);
nonZero		= logical(ones(M,1));    
maxIts = a.maxIts;


PRUNE_POINT	= a.maxIts * (a.prune_point/100);
LAST_IT		= 0;
ALPHA_MAX		= 1e12;
MIN_DELTA_LOGALPHA	= 1e-3;    


for i=1:maxIts
    % 
    % Prune large values of alpha
    % 
    nonZero	= (alpha<ALPHA_MAX);
    alpha_nz	= alpha(nonZero);
    w(~nonZero)	= 0;
    M		= sum(nonZero);
    % Work with non-pruned basis
    % 
    PHI_nz	= PHI(:,nonZero);
    Hessian	= (PHI_nz'*PHI_nz)*beta + diag(alpha_nz);
    [U,flag]		= chol(Hessian);
    Ui		= inv(U);
    w(nonZero)	= (Ui * (Ui' * PHIt(nonZero)))*beta;
    
    ED		= sum((t-PHI_nz*w(nonZero)).^2); % Data error
    betaED	= beta*ED;
    logBeta	= N*log(beta); 
    % Quick ways to get determinant and diagonal of posterior weight
    % covariance matrix 'SIGMA'
    logdetH	= -2*sum(log(diag(Ui)));
    diagSig	= sum(Ui.^2,2);
    % well-determinedness parameters
    gamma		= 1 - alpha_nz.*diagSig;
    
    % Compute marginal likelihood (approximation for classification case)
    marginal	= -0.5* (logdetH - sum(log(alpha_nz)) - ...
        logBeta + betaED + (w(nonZero).^2)'*alpha_nz);
    
    if(marginal==-Inf)
        break;
    end
    
    % Output info if requested and appropriate monitoring iteration
    if(a.algorithm.verbosity==2)
        fprintf('%5d> L = %.3f\t Gamma = %.2f (nz = %d)\t s=%.3f\n',...
            i, marginal, sum(gamma), sum(nonZero), sqrt(1/beta));
    end
    if ~LAST_IT
        % 
        % alpha and beta re-estimation on all but last iteration
        % (we just update the posterior statistics the last time around)
        % 
        logAlpha		= log(alpha(nonZero));
        if i<PRUNE_POINT
            % MacKay-style update given in original NIPS paper
            alpha(nonZero)	= gamma ./ w(nonZero).^2;
        else
            % Hybrid update based on NIPS theory paper and AISTATS submission
            alpha(nonZero)	= gamma ./ (w(nonZero).^2./gamma - diagSig);
            alpha(alpha<=0)	= inf; % This will be pruned later
        end
        anz		= alpha(nonZero);
        maxDAlpha	= max(abs(logAlpha(anz~=0)-log(anz(anz~=0))));
        
        % Terminate if the largest alpha change is judged too small
        if maxDAlpha<MIN_DELTA_LOGALPHA
            LAST_IT	= 1;
            if(a.algorithm.verbosity==1)
                fprintf('Terminating: max log(alpha) change is %g (<%g).\n', ...
                    maxDAlpha, MIN_DELTA_LOGALPHA);
            end
        end
        %
        % Beta re-estimate in regression (unless fixed)
        % 
        beta	= (N - sum(gamma))/ED;
    else
        % Its the last iteration due to termination, leave outer loop
        break;	% that's all folks!
    end
end
% Tidy up return values
weights	= w(nonZero);
used	= find(nonZero);

if a.algorithm.verbosity>=2
    fprintf('*\nHyperparameter estimation complete\n');
    fprintf('non-zero parameters:\t%d\n', length(weights));
    fprintf('log10-alpha min/max:\t%.2f/%.2f\n', ...
        log10([min(alpha_nz) max(alpha_nz)]));
end

a.Xsv=get(dat,used);
a.used=used;
a.marginal=marginal;
% !!! Note this difference!
a.alpha=weights;
a.beta=beta;
a.gamma=gamma;



if (~a.algorithm.do_not_evaluate_training_error)
     dat=test(a,dat);    
end
