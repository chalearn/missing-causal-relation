function [results,a] =  training(a,d)
       
  % [results,algorithm] =  training(algorithm,data,loss)

  disp(['training ' get_name(a) '.... '])

  Mmax = a.M;
  
  B = zeros(Mmax,3);% parameter to compute the B_m: 
                    % B(:,1) = index of the last m* used to compute B_m
                    % B(:,2) = index of v*
                    % B(:,3) = index of t*
  X = get_x(d);
  Y = get_y(d);
  
  nr = size(X,1); % number of raws
  nc = size(X,2); % number of columns
  
  tmp = zeros(nr,Mmax);% store the value of B_m(x_j)
  
  V = zeros(Mmax,nc); % store the v(m,k) 
  
  %% init
  tmp(:,1) = ones(nr,1);
   
  %% Index of the new basis function (M=1 is for the constant basis function)
  M=2;

  
  S = warning('off');
  %% Main loop (Forward stepwise)
  while (M<=Mmax),     
      lofref = Inf;
      
      %% 
      for m=1:M-1,
          vtmp = find(V(m,:)>0);
          tmp_v = setdiff([1:nc],vtmp);
          for  v  = tmp_v,
              tmp_t = find(tmp(:,m)>0);
              for t=tmp_t',
                  posx = (X(:,v)-X(t,v));
                  negx = -posx;
                  posx(find(posx<0))=0;
                  negx(find(negx<0))=0;
                  Xtmp = [tmp(:,1:M-1),tmp(:,m).*posx,tmp(:,m).*negx];
                  dtmp = data('tmp',Xtmp,Y);
                  atmp = a.child;
                  [r,atmp] = train(atmp,dtmp);
                  
                  %% Compute the lof
                  C = trace(Xtmp*pinv(Xtmp'*Xtmp)*Xtmp') + 1;
                  lof = group2vec(group(loss(r,'quadratic_loss')))/(C + a.d*M);
                                                                       
                  if lof<lofref, 
                      lofref=lof; mref = m; vref = v; tref = t; 
                      brefpos = tmp(:,m).*posx;
                      brefneg = tmp(:,m).*negx;
                  end;      
              end;%for t
          end;%for v          
      end;%for m
      B(M,1) = mref;
      B(M,2) = vref;
      B(M,3) = tref;
      B(M+1,1) = mref;
      B(M+1,2) = vref;
      B(M+1,3) = tref;
      
      %% Update the matrix tmp
      
      tmp(:,M) = brefpos;
      tmp(:,M+1) = brefneg;    
      
      % Update the matrix V
      
      V(M,:) = V(mref,:);
      V(M+1,:) = V(mref,:);
      V(M,vref) = 1;
      V(M+1,vref) = 1;
      M = M+2;
  end;% while
  
  
  
  %% Backward step
  Jref = [1:Mmax];
  Kref = Jref;
  atmp = a.child;
  dtmp = data('tmp',tmp,Y);
  [r,atmp] = train(atmp,dtmp);
  lofref = r.Y;
  for m=Mmax:-1:2,
      b=Inf;
      L = Kref;
      for n=2:m,
          K = setdiff(L,n);
          atmp = a.child;
          dtmp = data('tmp',tmp(:,K),Y);
          [r,atmp] = train(atmp,dtmp);
          
          %% Compute the lof
          C = trace(Xtmp*pinv(Xtmp'*Xtmp)*Xtmp') + 1;
          lof = group2vec(group(loss(r,'quadratic_loss')))/(C + a.d*M);
                                               
          if lof < b, b = lof; Kref = K; end;
          if lof < lofref, lofref = lof; Jref = K; end;
      end; %% for n
  end; %% for m
  
  atmp = a.child;
  dtmp = data('tmp',tmp(:,Jref),Y);
  [r,atmp] = train(atmp,dtmp);
  
  a.child = atmp;
  a.B=B;
  a.Xsv=d;
  a.J = Jref; 
  
   S = warning('on');
  
  
  results=test(a,d);
  








