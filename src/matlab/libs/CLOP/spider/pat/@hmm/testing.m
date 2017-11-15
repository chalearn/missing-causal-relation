function d =  testing(alg,d,loss_type)  

allY= d.X;  
% convert data into an cell arry (<-- do that later) TODO
if(~iscell(allY)) 
    Ytmp = {};
    for i = 1:size(allY,1)
        tmp = allY(i,:);
        Ytmp{i} = tmp(tmp ~= 0);         
    end
    allY = Ytmp;
    clear Ytmp; 
end
eps = 1e-20;

A = alg.alpha.X;
B = alg.alpha.Y;
pi = alg.pi;
if alg.testing_mode == 0 % calc most probable state seq and LL
 
    for i = 1:length(allY)% initial checking and nonsense
        pi = alg.pi;
        A = alg.alpha.X;
        B = alg.alpha.Y;
        
        Y = allY{i};
        tau = length(Y); [M,statesN] = size(B); if(size(pi,2)~=1) pi=pi(:); end
        assert(alg,tau>0); assert(alg,length(pi)==statesN); assert(alg,max(Y)<=M); assert(alg,min(Y)>=1);
        % initialize space
        delta=zeros(statesN,tau);  psi=zeros(statesN,tau); qq=zeros(1,tau);
        
        % compute bb
        bb = B(Y,:)';
        
        % take logs of parameters for numerical ease, then use addition
        pi = log(pi+eps); A = log(A+eps); bb = log(bb+eps);
        delta(:,1) = pi+bb(:,1); 
        psi(:,1)=0;
        
        for tt=2:tau
            [delta(:,tt),psi(:,tt)] = max((delta(:,tt-1)*ones(1,statesN)+A)',[],2);
            delta(:,tt) = delta(:,tt)+bb(:,tt);
        end
        
        [ll,qq(tau)] = max(delta(:,tau));
        ll=ll/tau; % loglikelihood divided by the length of the sequence
        for tt=(tau-1):-1:1
            qq(tt)=psi(qq(tt+1),tt+1);
        end
        
   
        statesEst{i} = qq; 
        allLL(i) = ll;
    end
       
    d=set_y(d,allLL);
    d=set_x(d,statesEst);   
end

if alg.testing_mode == 1 
    sz = d.X; % d.X stores amount X(1) and length X(2) of sequences
    for i = 1:sz(1)
        N = sz(2); % choose a random length  
        [M,statesN] = size(B);
 
     
        B = cumsum(B,1);
        pi = cumsum(pi);
        if(~issparse(A)) A = cumsum(A,2); end
        % don't do the cumsum beforehand if A is big but sparse to avoid
        % allocating memory for a full sized A
        
        [Y,states]=genseq(alg,N,A,pi,B);
        
        allStates{i} = Y;
        seqs{i} = states;
    end   
  
    d=set_y(d,seqs);
    d=set_x(d,allStates);   
 
    
end


d=set_name(d,[get_name(d) ' -> ' get_name(alg)]);   
