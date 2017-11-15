function [res,alg] = training(alg,d,loss_type)

disp(['training ' get_name(alg) '.... '])

Y = d.X;  
% convert data into an cell arry (<-- do that later) TODO
if(~iscell(Y)) 
    Ytmp = {};
    for i = 1:size(Y,1)
        tmp = Y(i,:);
        Ytmp{i} = tmp(tmp ~= 0);         
    end
    Y = Ytmp;
    clear Ytmp; 
end

%%%%%%%%%%%determine parameters %%%%%%%%%%%%%%%%%%%%%
M = max(cat(2,Y{:})); alg.M = M; %find highest index of alphabet
updateflags= alg.updateflags; %determine which parameter shall be updated
maxiter= alg.maxiter;   % maximal number of EM-iterations
tol= alg.tol;       % fractional change of loglokelihood, which stops the iteration
B = alg.B;  % output probabilities
A = alg.A;  % number of states or the transition probs
pi = alg.pi; % pi(i) is probability to start in state i
% initialize flags

% initialize A,pi,B
if(size(A,1)==1) statesN=A; A=[]; else statesN=size(A,1); end
if(isempty(A)) 
    A = rand(statesN,statesN); 
    A = A./(sum(A,2)*ones(1,statesN));  % make each row sum to unity
end
if(isempty(pi)) pi = rand(statesN,1); pi=pi/sum(pi);   end
if(isempty(B))  B = rand(M,statesN); B = B./(ones(M,1)*sum(B,1));    end
                                 % make each col sum to unity


if(isempty(updateflags)) updateflags=[1,1,1]; end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ll=[-1e200,-1e199];

while(((ll(end)-ll(end-1))/abs(ll(end)) > tol) & (length(ll)<=maxiter+3))
  [A,pi,B,llnew] = innerLoop(alg,Y,A,pi,B,updateflags);
  ll = [ll,mean(llnew)];
  fprintf(1,'Iteration:\t%d\tlogLikelihood:%f',length(ll)-2,ll(end));
  if(length(ll)>3) fprintf(1,'\tdiff:%f',ll(end)-ll(end-1)); end
  fprintf(1,'\n');
end
ll=ll(3:end);

alg.alpha = data(A,B);
alg.pi = pi;
alg.LL = ll;
res = test(alg,d);

  
  
  
