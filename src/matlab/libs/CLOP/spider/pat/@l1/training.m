function [r,a] =  training(a,d)
       
  if a.algorithm.verbosity>0
    disp(['training ' get_name(a) '.... '])
  end

  Y=get_y(d); X=get_x(d);  l = length(Y); dd = size(X,2);
  
  % construct the lower/upper bound vector
  lower = [zeros(1,2*dd+2)];
  upper = [Inf*ones(1,2*dd+2)];
  
  % construct the A matrix
  A = X; b=Y';
  H = zeros(l);
  c= ones(1,l);  
%   min f'*x    subject to:   A*x <= b 
  options= optimset('MaxIter',10000);
%  w=linprog([ones(1,dd) ones(1,dd) 0 0],[-diag(Y)*X diag(Y)*X  -Y Y],-ones(1,l),[],[],lower,upper);
% a.w=w(1:dd)-w(dd+1:dd*2);
% a.b0=w(2*dd+1) - w(2*dd+2);
 

%% Andre optimization...

m=l; n=dd;
A=[diag(Y)*X, -diag(Y)*X, Y, -Y, -eye(m)];
scale=ones(1,dd)';
Obj = [scale',scale',0,0,zeros(1,m)];
b = ones(m,1);
x = slinearsolve(Obj',A,b,Inf);
a.w = x(1:n)-x(n+1:2*n);
a.b0 = x(2*n+1)-x(2*n+2);


r=test(a,d);
  
