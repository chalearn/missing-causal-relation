function [res,alg] =  training(a,d)
  [X Y]  = get_xy(d);
  [l,n,k]=get_dim(d);
  disp(['training ' get_name(a) '.... '])
  feat=a.feat; % number of features desired 
  rank=[];
  w=zeros(n,k);
  %%%% for all features
  for i=1:n,
      disp(['Feature number ' num2str(i) '/' num2str(n) '.']);
      distq = zeros(k,k);
      %% Compute the distance matrix wrt. golub's score
      for p=1:k,
          for q=p+1:k,
            corr = mean(X(Y(:,p)==1,i))-mean(X(Y(:,q)==1,i));
            st   = std(X(Y(:,p)==1,i));
            st   = st+std(X(Y(:,q)==1,i));
            if st<10*eps, st=10000; end;
            distq(p,q) = abs(corr/st); 
            distq(q,p) = distq(p,q);
          end;
      end;  
      
      %% Cluster the classes into two groups
      disttmp = distance('custom',distq);
      tmp = a.child;
      tmp.child=disttmp;
      a.child=tmp;
      dtmp = data('tmp',[1:k]',[1:k]');
      [r] = train(a.child,dtmp);
      
      %% compute the score for one group of class vs the other
      tmp1=find(r.X==1);
      tmp2=find(r.X==2);
      tmpind1 = find(sum(Y(:,tmp1)'==1)>0);
      tmpind2 = find(sum(Y(:,tmp2)'==1)>0);
      
      corr = mean(X(tmpind1,i))-mean(X(tmpind2,i));
      st   = std(X(tmpind1,i));
      st   = st+std(X(tmpind2,i));
      if st<10*eps, st=10000; end;
      score(i) = abs(corr/st); 
      w(i,tmp1) = score(i);
      w(i,tmp2) = -score(i);
  end;%% for i
  
  [dummy,rank] = sort(-score);
  a.rank=rank;
  
    %% compute b
    btmp = zeros(k,k);
    for i=1:k,
        for j = i+1:k,
            Posidx = find(Y(:,i)==1);
            Posjdx = find(Y(:,j)==1);
            milieu = (mean(X(Posidx,:))+mean(X(Posjdx,:)))/2;
            btmp(i,j)= -(w(:,i)-w(:,j))'*milieu';
            btmp(j,i)= -btmp(i,j);
        end;
    end;
    %% output
    a.b0 = btmp;
    a.d=d;
    a.w=w;
    res=test(a,d);
    alg=a; 