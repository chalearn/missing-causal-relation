function [d,a] =  training(a,d)

  
  disp(['training ' get_name(a) '.... '])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Prepare for the optimization wrt. sigma

% warning('spectral/training: ICRM DEMO version')
K = get_distance(a.child,d,d).^2;
Ktmp = K + diag(Inf*ones(size(K,1),1));
sigma_min = min(min(Ktmp));
sigma_max = max(max(K));
if ~isempty(a.sigma),
    sigmatmp=a.sigma;
else
    %%% build the research line
    mid = mean(mean(K));
    midmax = min([2*mid,sigma_max]);
    midmin = max([mid/2,sigma_min]);
    tmp = [mid:0.1*mid:midmax];
    tmp = [[midmin:0.1*mid/2:0.9*mid],tmp];
    logsigmin = log2(sigma_min);
    logsigmax = log2(sigma_max);
    sigmatmp = [2.^[logsigmin:0.5:(real(log2(midmin))-0.5)],tmp, 2.^[real(log2(midmax))+0.5:0.5:logsigmax]];    
end;
%%% loop for the score
score = zeros(length(sigmatmp),1);
for j=1:length(sigmatmp),
    %%% Computation of the basic matrix 
    Ktmp = real(exp(-K.^2/(2*sigmatmp(j)^2)) - eye(size(Ktmp)));
    if isempty(find(real(sum(Ktmp))<10*eps))    
        tmp = real(1./sqrt(sum(Ktmp)));    
        Dtmp = tmp'*tmp;
        L = Ktmp.*Dtmp;
        %%% Select the k largest eigenvectors
	try %% try the eigen value decomposition
            [u,v] = eig(L);
            tmp = diag(v);
            [dummy,y] = sort(-tmp);
            Feig =u(:,y(1:a.k));
            %%% Normalize them
            for i=1:size(Feig,1),
                if norm(Feig(i,:))~=0,
                    Feig(i,:) = Feig(i,:)/norm(Feig(i,:));
                end;
            end;
            %%% Performs k-means on them
            dtmp = data('tmp',Feig,Feig);
	    b=kmeans;
            b.k=a.k;
            b.algorithm.verbosity=0;
            [res,b] = train(b,dtmp);
            Yfin = res.X;
            %%% pour voir
            if 0,
                Y = get_y(d);
                tmp = find(Y==1);
                figure(2);
                plot(Feig(tmp,1),Feig(tmp,2),'xr');
                hold;
                tmp=find(Y==2);
                plot(Feig(tmp,1),Feig(tmp,2),'xb');
                disp(['Score: ' num2str(distortion(b,dtmp))]);
                hold;
%                 pause;                
            end;
	    if isempty(a.sigma),
                score(j) = distortion(b,dtmp);
            end;
        catch %% the eigenvalue decomposition is not good
	  score(j)=Inf;
        end;
    else
        score(j)=Inf;
    end; %% if isempty
end;%% j

if isempty(a.sigma)
    [u,v] = min(score(1:j));
    a.sigma = sigmatmp(v);
else
    v=1;
end;

%%% Retrain for the best score
if (v~=length(sigmatmp)),
    Ktmp = real(exp(-K.^2/(2*sigmatmp(v)^2))- eye(size(Ktmp)));
    tmp = real(1./sqrt(sum(Ktmp)));
    Dtmp = tmp'*tmp;
    L = Ktmp.*Dtmp;
    %%% Select the k largest eigenvectors
    [u,v] = eig(L);
    tmp = diag(v);
    [dummy,y] = sort(-tmp);
    Feig =u(:,y(1:a.k));
    %%% Normalize them
    for i=1:size(Feig,1),
        Feig(i,:) = Feig(i,:)/norm(Feig(i,:));
    end;
    %%% Performs k-means on them
    dtmp = data('tmp',Feig,Feig);   
    b=kmeans;
    b.k=a.k;    
    [res,b] = train(b,dtmp);
    Yfin = res.X;    
end;
%keyboard;
%%% Output the result
a.d = set_y(d,Yfin);

d=set_x(d,Yfin);  d.name=[get_name(d) ' -> ' get_name(a)]; 

%results = data([a.algorithm.name ' results '  ' data: ' d.name],Yfin,[]);
