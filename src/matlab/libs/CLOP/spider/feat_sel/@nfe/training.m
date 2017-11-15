function [res,alg] =  training(a,d)
% [results,algorithm] =  train(algorithm,data,trn)
  [l,n,k]= get_dim(d);
  disp(['training ' get_name(a) '.... '])
   
  feat=a.feat; % number of features desired 
  whatsleft=ones(a.k,1)*[1:n];   
  rank=[];
  
  %% design of the kernel tpoly
  for i=1:a.k,
    kerp{i}=[1:n];
  end;
  k=kernel('tpoly',kerp);
  
  %% if we use the previous trainings
  if a.algorithm.use_prev_train==1&a.algorithm.trained==1,
      d=get(d,[],a.rank(1:a.feat));
  else
    while n>feat 
        %% change the kernel
        k=kernel('tpoly',kerp);
        a.child.kernel=k;        
        [r,a.child]=train(a.child,d);
        w=abs(get_w(a.child));
        if n>a.speed
                next=floor(n/2);               %% choose number of features to take 
        else
                next=1;                        %% slow mode- remove one feature 
        end
        if n-next<feat next=n-feat; end
        keep=n-next; 
        
        for i=1:length(kerp),
            [val,index(i,:)]= sort(-abs(w(i,:)));           
            kerp{i} = kerp{i}(index(i,keep+1:length(index)));
        end;
        rank=[whatsleft(index(:,keep+1:length(index))) rank];
                
        %%% HERE
        %%% update kerp !!
        
        
        whatsleft=whatsleft(index(1:keep));                   
    %%        d=get(d,[],index(1:keep));     %% cut features
        n=keep;
        disp(['feat = ' num2str(n)]);
    end 
  %  rank=[whatsleft rank];
    a.feat=feat;
    a.rank=rank;
  end;
  if a.output_rank==1  %% output selected features, not label estimates
    res=d;
  else
    [res,a.child]=train(a.child,d);
  end
  
  alg=a;
  