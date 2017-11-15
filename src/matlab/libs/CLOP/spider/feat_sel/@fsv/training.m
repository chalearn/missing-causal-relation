function [d,alg] =  training(al,d)
  % [results,algorithm] =  train(algorithm,data,loss)
  disp(['training ' get_name(al) '.... '])
  
loop=0;
finished=0;
alpha=al.alpha;
X = get_x(d);
Y = get_y(d);
[m,n] = size(X);
v = zeros(n,1);

 if al.algorithm.use_prev_train==1&al.algorithm.trained==1,
      %d=get(d,[],a.rank(1:a.feat));
      alg=al;
  else
while (~finished),
    loop=loop+1;    
    scale = alpha*exp(-alpha*v);
    
    A=[diag(Y)*X, -diag(Y)*X, Y, -Y, -eye(m)];
    Obj = [scale',scale',0,0,zeros(1,m)];
    b = ones(m,1);
    x = slinearsolve(Obj',A,b,Inf);
    w = x(1:n)-x(n+1:2*n);
    b0 = x(2*n+1)-x(2*n+2);
    vnew=abs(w);
    
    if (norm(vnew-v,1)<10^(-5)*norm(v,1)),
        finished=1;
    else
        v=vnew;
    end;
    if (loop>20),
        finished=1;
    end;
    nfeat=length(find(vnew>100*eps));
    disp(['Iteration' num2str(loop) ' - feat ' num2str(nfeat)]);
    if nfeat<al.feat,
        finished=1;
    end;
end;
[dum,ind] = sort(-abs(w));
 alg=al;  
 alg.w=w';
 alg.b0=b0; 
 alg.rank=ind;
end;
  
 d=test(alg,d);

