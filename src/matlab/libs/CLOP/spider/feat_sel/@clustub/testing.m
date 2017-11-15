function results = testing(a,d)
 if a.output_rank==1  %% output features with best correlation scores
   feat=a.feat; if isempty(feat) feat=length(a.rank);   end;
   results=get(d,[],a.rank(1:feat));     %% perform feature selection
 else
   X = get_x(d);
   [m,n,Q] = get_dim(d);
   feat=a.feat;
   if isempty(feat) feat=size(X,2); end;
   f=a.rank(1:feat); 
   
    %% Computation of b
    btmp=zeros(Q,Q);
    Xtrain=get_x(a.d);
    Ytrain=get_y(a.d);
    
    for i=1:Q,
        for j = i+1:Q,
            Posidx = find(Ytrain(:,i)==1);
            Posjdx = find(Ytrain(:,j)==1);
            milieu = (mean(Xtrain(Posidx,f))+mean(Xtrain(Posjdx,f)))/2;
            btmp(i,j)= -(a.w(f,i)-a.w(f,j))'*milieu';
            btmp(j,i)= -btmp(i,j);
        end;
    end;
       
    % compute the values of b_i s.t. sum_i b_i = 0
    bo = zeros(Q,1); % the bias vector
    for i=1:Q,
      temp = sum(btmp(i,:))/Q;
      for j=1:Q,
        bo(j) =bo(j)+temp-btmp(i,j);
      end;
    end;
    bo=bo/Q;
    %% compute the output on the test set
    Yest = X(:,f)*a.w(f,:) + ones(size(X,1),1)*bo';   
    [r,Ytmp2]=max(Yest,[],2);
    Yest = -ones(size(Yest));
    for i=1:length(Ytmp2),
        Yest(i,Ytmp2(i))=1;
    end;        
   d=set_x(d,Yest);
   results=d;
 end;
 results=set_name(results,[get_name(results) ' -> ' get_name(a)]);
 
  
 
