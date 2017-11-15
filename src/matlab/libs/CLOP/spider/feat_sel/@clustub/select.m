function score = select(a,ind),
%% select feature number ind and output a figure with the 
%% expression. score = score given by the method
%% ind can be a set of indices. The figure is then a subplot
score=[];
t=ceil(sqrt(length(ind)));
loop=0;
if size(ind,1)>1, ind=ind'; end;
for i=ind,
      loop=loop+1;
     [X Y]  = get_xy(a.d);
     [l,n,k]=get_dim(a.d);
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
      u=[tmp1;tmp2];
      %%%%%%%%
      subplot(t,t,loop);
      colormap('pink');
      %%%%%%%%
      title(['Feature number ' num2str(i)]);
      imagesc(distq(u,u));
      colorbar;
      tmpind1 = find(sum(Y(:,tmp1)'==1)>0);
      tmpind2 = find(sum(Y(:,tmp2)'==1)>0);
      
      corr = mean(X(tmpind1,i))-mean(X(tmpind2,i));
      st   = std(X(tmpind1,i));
      st   = st+std(X(tmpind2,i));
      if st<10*eps, st=10000; end;
      score =[score, corr/st]; 
  end;