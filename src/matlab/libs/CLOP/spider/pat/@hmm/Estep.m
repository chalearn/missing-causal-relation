function [gamma,eta,rho] = Estep(alg,Y,A,pi,B,updateflags)

% [gamma,eta,rho] = Estep(alg,Y,A,pi,B,updateflags)
%
% Forward Backward for DISCRETE symbol HMMs
%
% Y is a vector of integers (observed symbols)
%
% A(i,j) is the probability of going to j next if you are now in i
% pi(j)  is the probability of starting in state j
% B(m,j) is the probability of emitting symbol m if you are in state j
%
% updateflags controls the update of parameters
%   it is a three-vector whose elements control the updating of
%   [A,pi,B] -- nonzero elements mean update that parameter
%
% gamma(i,t) = p(x_t=i|Y) are the state inferences
% eta(i,j) = sum_t p(x_t=i,x_t+1=j|Y) are the transition counts
% rho(t) = p(y_t | y_1,y2,...y_t-1) are the scaling factors
%

if(nargin<6) 
    updateflags=[1,1,1]; 
end

gamma=[]; eta=[]; rho=[];

if(any(updateflags))
    
    % initial checking and nonsense
    tau = length(Y); [M,statesN] = size(B); if(size(pi,2)~=1) pi=pi(:); end
    assert(alg,tau>0); assert(alg,length(pi)==statesN); assert(alg,max(Y)<=M); assert(alg,min(Y)>=1);
    
    % initialize space
    alpha=zeros(statesN,tau); beta=zeros(statesN,tau); rho=zeros(1,tau);
    
    % compute bb
    bb = B(Y,:)';
    
    % compute alpha, rho, beta
    alpha(:,1) = pi.*bb(:,1);
    rho(1)=sum(alpha(:,1));
    alpha(:,1) = alpha(:,1)/rho(1);
    for tt=2:tau
        alpha(:,tt) = (A'*alpha(:,tt-1)).*bb(:,tt);
        rho(tt) = sum(alpha(:,tt));
        alpha(:,tt) = alpha(:,tt)/rho(tt);
    end
    beta(:,tau) = 1;
    for tt=(tau-1):-1:1
        beta(:,tt) = A*(beta(:,tt+1).*bb(:,tt+1))/rho(tt+1); 
    end
    
    % compute eta, AND sum it over all time (but don't normalize the result)
    if(updateflags(1))
        eta = zeros(statesN,statesN);
        for tt=1:(tau-1)
            etatmp = A.*(alpha(:,tt)*(beta(:,tt+1).*bb(:,tt+1))');
            eta = eta+etatmp/rho(tt+1);
            %    eta = eta+etatmp/sum(etatmp(:)); % same thing as above, just slower
        end
        %  eta = eta./(sum(eta,2)*ones(1,statesN)); % this would make each row sum to unity
        % but doesn't work with multiple seqs.
    end
    
    % compute gamma
    if(any(updateflags(2:3)))
        gamma = (alpha.*beta);  % here we could just say alpha=alpha.*beta
        % and avoid allocating the gamma memory
        %  gamma = gamma./(ones(statesN,1)*sum(gamma,1)); % only to avoid numerical noise
        % since gamma should be normalized
    end
    
    
end
