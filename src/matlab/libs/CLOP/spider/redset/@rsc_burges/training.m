function [d, a] =  training(a,d)
  
  if a.algorithm.verbosity>0
    disp(['calculating reduced set vectors by burges method for ', get_name(a.child)])
    disp('initializing...')
  end
  
  % train algorithm first
  if isempty(a.child.alpha) | ~isempty(a.alpha) 
   [r a.child]=train(a.child,d);
  end    
  
  % set RNG
  rand('state',sum(100*clock));             
  
  % get data from old algo
  alpha = a.child.alpha;                    
  svs = find(sum(abs(alpha)',1)>1e-5);
  alpha = alpha(svs);
  Xsv = get(a.child.Xsv,svs);
  kerparam = a.child.kerparam;              
  range = max(max(abs(Xsv.X)));
  dim = size(Xsv.X,2);
  Kxx = calc(a.child.child,Xsv);
  a.child.Xsv = Xsv;
  a.child.alpha = alpha;
  k = a.child.child;
  
  % calculate desired # of rsvs
  if a.rsv < 1
      a.rsv = ceil(sum(abs(alpha)>0) * a.rsv);
  end;
  
  disp(['compressing for ', num2str(a.rsv) , ' rsvs']);

  dw(1) = alpha' * Kxx * alpha;

  gamma = [];
  z = [];
  x = [gamma, z];
  
  it = 1;
  
  % burges phase 1
  
  for it = 1:a.rsv
  if it == 1
      f_before=dw(1);
  else
      f_before= fz(z(size(z,1),:)',a.child,z,gamma, Kxx);
  end;
  % initialization
  disp(['calculating reduced set vector ', num2str(it)]);
  gamma(it,1) = (-1)^(it+1); % set gamma(i) to +/- 1

  % try different starting values to avoid local minima
  for init = 1:a.stv
    iz{init} = z;
    index = ceil(rand(1)*size(Xsv.X,1));
    iz{init}(it,:) = get_X(Xsv,index);
      
    % step 1: first optimization
    % minimize with regard to z(i) while keeping gamma(i) fixed
    disp('optimize z ...')
    if a.minimizer
      iz{init}(it,:) = minimize_z(a,a.child, iz{init}, gamma, a.max_it, a.eps, Kxx,a.deriv);
    else
      iz{init}(it,:) = minimize(iz{init}(it,:)','min_z',a.max_it,a, iz{init}, gamma, Kxx,a.deriv);
    end;
      

    idw(init) = fz(iz{init}(size(iz{init},1),:)',a.child,iz{init},gamma, Kxx);
  end;
  % select starting value with lowest targest function after minimization
  [n minit] = min(idw);
  z = iz{minit};  
  
  % step 2: compute optimal gamma(i)
  disp('compute gamma...')
  z_new = data(z(size(z,1),:));
  z_old = data(z(1:size(z,1)-1,:));

  if (size(z,1) == 1)
    gamma(it,:) = 1 / calc(k, z_new) * (calc(k, Xsv, z_new) * alpha);
  else
    gamma(it,:) = (1 / calc(k, z_new)) * ( (calc(k, Xsv, z_new) * alpha) - (calc(k, z_old, z_new) * gamma(1:size(z,1)-1,1)));
  end;
  
  f_after= fz(z(size(z,1),:)',a.child,z,gamma, Kxx);
  disp('-----------------------')
  disp('gradient descent stats:')
  disp(strcat('start f:', num2str(f_before)));
  disp(strcat('end f  :', num2str(f_after)));
  disp(strcat('decr   :', num2str(f_before - f_after)));
  disp('-----------------------')
 

  % step 3: second optimization
  % minimize with regard to z(i) and gamma(i)
  disp('optimize gamma and z ...')
  x(it,:) = [gamma(it,:), z(it,:)]; % concat G and Z
  if a.minimizer
    x(it,:)  = minimize_zg (a,a.child, x, a.max_it, a.eps, Kxx,a.deriv); 
  else
    x(it,:) = (minimize(x(it,:)','min_zg',a.max_it,a, x, Kxx,a.deriv))';
  end;
  gamma(it,:) = x(it,1);
  z(it,:) = x(it,2:size(x,2));

  % step 4: recalculate all gammas
  disp('recalculate gammas ...')
  data_z = data(z);
  if it==1
   gamma = calc(k, Xsv, data_z)*alpha;
  else
   gamma = minres(calc(k, data_z),calc(k, Xsv, data_z) * alpha);
  end;
  x = [gamma z];

  dw(it+1) = fzg(x(size(x,1),:)', a.child, x, Kxx);
end;

if a.phase2
    disp('optimizing in phase 2...')
    if a.minimizer
      x  = minimize_all(a,a.child,x,a.max_it, a.eps, Kxx,a.deriv);
    else
     x = reshape((minimize(reshape(x,size(x,1)*size(x,2),1),'min_all',a.max_it,a, x, Kxx,a.deriv))',size(x,1),size(x,2));
   end;
      
 z = x(:,2:size(x,2));
 gamma = x(:,1);
 dw(it+2) = fzg(x(size(x,1),:)', a.child, x, Kxx);
 disp('-----------------------')
  disp('phase 2 stats:')
  disp(strcat('start f:', num2str(dw(it+1))));
  disp(strcat('end f  :', num2str(dw(it+2))));
  disp(strcat('decr   :', num2str(dw(it+1) - dw(it+2))));
  disp('-----------------------')
end;


% set results
a.w2 = dw(length(dw));
a.delta_w = dw(1) - a.w2;
a.dw = dw;
a.Xsv = data(z);
a.alpha = gamma;
a.b0 = a.child.b0;

disp(' ')
disp(' ')
disp(' ')
disp('------------------------------------------------------')
disp('stats for reduced set contruction with burges method')
disp('------------------------------------------------------')
disp(['original support vectors: ' num2str(sum(abs(alpha)>0))]);
disp(['reduced set vectors found: ' num2str(a.rsv)]);
disp(['decrease in ||w-w*||^2: ' num2str(a.delta_w)]);
disp(['final value of ||w-w*||^2: ' num2str(a.w2)]);
disp('------------------------------------------------------')

 
  d = test(a,d);





% subfunction fz
function ret = fz(x0, a, Z, G, Kxx)
% returns value of target function ||w-w*||^2
alpha = a.alpha;
k = a.child;
x0 = x0';
Z(size(Z,1), :) = x0;
ret = alpha' * Kxx * alpha + G' * calc(k, data(Z)) * G - 2 * alpha' * calc(k, data(Z), data(a.Xsv.X)) * G;

% subfunction fzg
function ret = fzg(x0, a, X, Kxx)
% returns value of target function ||w-w*||^2
x0 = x0';
alpha = a.alpha;
k = a.child;
X(size(X,1), :) = x0;
ret = alpha' * Kxx * alpha + X(:,1)' * calc(k, data(X(1:size(X,1), 2:size(X,2)))) * X(:,1) - 2 * alpha' * calc(k, data(X(1:size(X,1), 2:size(X,2))), data(a.Xsv.X)) * X(:,1);

% subfunction fall
function ret = fall(x0, a, X, Kxx)
% returns value of target function ||w-w*||^2
alpha = a.alpha;
k = a.child;
X = reshape(x0, size(X,1), size(X,2));
ret = alpha' * Kxx * alpha + X(:,1)' * calc(k, data(X(1:size(X,1), 2:size(X,2)))) * X(:,1) - 2 * alpha' * calc(k, data(X(1:size(X,1), 2:size(X,2))), data(a.Xsv.X)) * X(:,1);

% subfunction dfz
function ret = dfz(rs,x0, a, Z, G, Kxx, deriv)
% calculates gradient numerically with regard to last line in Z (to z only)

gamma =G;
S = a.Xsv.X;
alpha = a.alpha;
k= a.child;
sigma = k.kerparam;
Z(size(Z,1), :) = x0';

switch deriv
    case 'num'
        eps = .0001;
        ret = zeros(length(x0),1);
        for j = 1:length(x0)
            x1 = x0;
            x1(j) = x1(j) + eps;
            ret(j) = (fz(x1, a, Z,G, Kxx) - fz(x0, a, Z,G,Kxx))/eps;
        end;
    otherwise
        dz = feval(deriv,rs,alpha,gamma,sigma,Z,S,k,size(Z,1));
        ret = dz;

%         eps = .0001;
%         ret1 = zeros(length(x0),1);
%         for j = 1:length(x0)
%             x1 = x0;
%             x1(j) = x1(j) + eps;
%             ret1(j) = (fz(x1, a, Z,G, Kxx) - fz(x0, a, Z,G,Kxx))/eps;
%         end;
%         [ret1, ret]
end;


% subfunction dfzg
function ret = dfzg(rs,x0, a, X, Kxx, deriv)
% calculates gradient with regard to last line in X (to gamma
% and z)

X(size(X,1), :) = x0';
Z = X(1:size(X,1),2:size(X,2));
gamma =X(1:size(X,1),1);
S = a.Xsv.X;
alpha = a.alpha;
k= a.child;
sigma = k.kerparam;
z_k = Z(size(Z,1),1:size(Z,2));


ret(1) = 2*(-alpha' * calc(k,data(z_k),data(S)) +gamma'*calc(k,data(z_k),data(Z)));
switch deriv
    case 'num'
        eps = .0001;
        tmp = ret(1);
        ret = zeros(length(x0),1);
        ret(1)=tmp;
        for j = 2:length(x0)
            x1 = x0;
            x1(j) = x1(j) + eps;
            ret(j) = (fzg(x1, a, X, Kxx) - fzg(x0, a, X,Kxx))/eps;
        end;
    otherwise 
        dz = feval(deriv,rs,alpha,gamma,sigma,Z,S,k,size(X,1));
        ret = [ret(1);dz];    
        
end;

% subfunction dfall
function ret = dfall(rs,a, X, Kxx,deriv)
% calculates gradient with regard to whole X

Z = X(1:size(X,1),2:size(X,2));
gamma =X(1:size(X,1),1);
S = a.Xsv.X;
alpha = a.alpha;
k= a.child;
sigma = k.kerparam;
switch deriv
   case 'num'
        eps = .0001;
        [sX1 sX2] = size(X);
        x0 = reshape(X,1,sX1*sX2);
        tmp = zeros(length(x0),1);
        for j = 1:length(x0)
            x1 = x0;
            x1(j) = x1(j) + eps;
            tmp(j) = (fall(x1, a, X, Kxx) - fall(x0, a, X, Kxx))/eps;
        end;
        ret = tmp';
   otherwise
        ret=[];
        [sX1 sX2] = size(X);
        for m = 1:sX1
          z_k = Z(m,1:size(Z,2));
          tmp1(m) = 2*(-alpha' * calc(k,data(z_k),data(S)) +gamma'*calc(k,data(z_k),data(Z)));          
          tmp2(m,1:size(Z,2)) = feval(deriv,rs,alpha,gamma,sigma,Z,S,k,m)';
        end;
        ret= [tmp1',tmp2];   
        ret=reshape(ret,1,sX1*sX2);
%         eps = .0001;
%         [sX1 sX2] = size(X);
%         x0 = reshape(X,1,sX1*sX2);
%         tmp = zeros(length(x0),1);
%         for j = 1:length(x0)
%             x1 = x0;
%             x1(j) = x1(j) + eps;
%             tmp(j) = (fall(x1, a, X, Kxx) - fall(x0, a, X, Kxx))/eps;
%         end;
%         ret1 = tmp';
%         [ret1; ret]
end;
ret= ret';





% subfunction fallgrad
 function ret = fallgrad(alpha,x0,grad, a, X, Kxx)
   ret = fall(x0 + alpha*grad, a, X, Kxx);
   

% subfunction minimize_all
function ret = minimize_all(rs,a, X, max_it, eps, Kxx,deriv)
% minimizes F for phase 2 of burges
% search parameters

% statistics init
start_x0 = reshape(X,1,size(X,1)*size(X,2))'; % position is last initialized vector
start_f = fall(start_x0, a, X, Kxx);
grad = - dfall(rs,a, X, Kxx,deriv);
iter = 1;
f =start_f;

while  norm(grad) > .01 & iter < max_it
  x0 = reshape(X,1,size(X,1)*size(X,2))'; % position is last initialized vector
  grad = -dfall(rs,a, X, Kxx);
  norm(grad)
  alphamin = fminsearch(fallgrad,0,alpha,x0,grad, a, X, Kxx);
  X = reshape(x0 + alphamin*grad,size(X,1),size(X,2));
  f = fall(reshape(X,1,size(X,1)*size(X,2))', a, X, Kxx);
  iter =  iter+1;
end;
disp('-----------------------')
disp('gradient descent stats:')
disp(strcat('start f:', num2str(start_f)));
disp(strcat('end f  :', num2str(f)));
disp(strcat('decr   :', num2str(start_f - f)));
disp('-----------------------')
ret = X;



%  % subfunction minimize_z
%  function ret = minimize_z(a, Z, G, max_it, eps, Kxx,deriv)
%  % minimizes F for phase 1 of burges after last line in Z
%  % search parameters
%  sw = .1; % stepwidth
%  sd = 70; % step density
%  pos = size(Z,1);
%  
%  % statistics init
%  start_x0 = Z(pos,:)'; % starting v
%  start_f = fz(start_x0, a, Z, G, Kxx); % starting functional value
%  grad = -dfz(start_x0, a, Z, G, Kxx,deriv); % starting gradient
%  iter = 1;
%  f = start_f;
%  
%  % do gradient descent
%  
%  while  norm(grad) > eps & iter < max_it
%    x0 = Z(pos,:)'; % position is last initialized vector
%    grad = -dfz(x0, a, Z, G, Kxx,deriv);  
%    as = linspace(0,sw,sd);
%    for  i=1:sd
%      fval(i) = fz(x0 + as(i)*grad, a, Z, G, Kxx);
%    end;
%    [val it] = min(fval);
%    alpha = as(it);
%    Z(pos,:) = (x0 + alpha*grad)';
%    f = fz(Z(pos,:)', a, Z, G, Kxx);
%    iter =  iter+1;
%  end;
%   ret = Z(pos,:);
 

% subfunction fzgrad
 function ret = fzgrad(alpha,x0,grad, a, Z, G, Kxx)
   ret = fz(x0 + alpha*grad, a, Z, G, Kxx);
 

 
 
 % subfunction minimize_z
function ret = minimize_z(rs,a, Z, G, max_it, eps, Kxx,deriv)
% minimizes F for phase 1 of burges after last line in Z
% search parameters
pos = size(Z,1);
% statistics init
start_x0 = Z(pos,:)'; % starting v
start_f = fz(start_x0, a, Z, G, Kxx); % starting functional value
grad = -dfz(rs,start_x0, a, Z, G, Kxx,deriv); % starting gradient
iter = 1;
f = start_f;

% do gradient descent

while  norm(grad) > .001 && iter < max_it
  x0 = Z(pos,:)'; % position is last initialized vector
  grad = -dfz(rs,x0, a, Z, G, Kxx,deriv);  
  alphamin = fminsearch(fzgrad,0,alpha,x0,grad, a, Z, G, Kxx);
  Z(pos,:) = (x0 + alphamin*grad)';
  f = fz(Z(pos,:)', a, Z, G, Kxx);
  iter =  iter+1;
end;
 ret = Z(pos,:);

 
% subfunction fzggrad
 function ret = fzggrad(alpha,x0,grad, a, X, Kxx)
   ret = fzg(x0 + alpha*grad, a, X, Kxx);



% subfunction minimize_zg
function ret = minimize_zg(rs,a, X, max_it, eps, Kxx,deriv)
% minimizes F for phase 1 of burges after last line in X
pos = size(X,1);

% statistics init
start_x0 = X(pos,:)'; % position is last initialized vector
start_f = fzg(start_x0, a, X, Kxx);
grad = - dfzg(rs,start_x0, a, X, Kxx,deriv);
iter = 1;
f =start_f;

while  norm(grad) > .01 & iter < max_it
  x0 = X(pos,:)'; % position is last initialized vector
  grad = -dfzg(rs,x0, a, X, Kxx,deriv);
  %norm(grad)
  alphamin = fminsearch(fzggrad,0,alpha,x0,grad, a, X, Kxx);
  X(pos,:) =( x0 + alphamin*grad)';
  f = fzg(X(pos,:)', a, X, Kxx);
  iter =  iter+1;
end;
disp('-----------------------')
disp('gradient descent stats:')
disp(strcat('start f:', num2str(start_f)));
disp(strcat('end f  :', num2str(f)));
disp(strcat('decr   :', num2str(start_f - f)));
disp('-----------------------')
ret = X(pos,:);


function [f, df] = min_z(x0, rs, Z, G, Kxx,deriv)


f = fz(x0, rs.child, Z, G, Kxx);
df = dfz(rs,x0, rs.child, Z, G, Kxx,deriv);


function [f, df] = min_zg(x0, rs, X, Kxx,deriv)

f = fzg(x0, rs.child, X, Kxx);
df = dfzg(rs,x0, rs.child, X, Kxx,deriv);


function [f, df] = min_all(x0, rs, X, Kxx,deriv)

X = reshape(x0,size(X,1),size(X,2));
f = fall(x0, rs.child, X, Kxx);
df = dfall(rs,rs.child, X, Kxx,deriv);




function [X, fX, i] = minimize(X, f, length, P1, P2, P3, P4, P5);

% Minimize a continuous differentialble multivariate function. Starting point
% is given by "X" (D by 1), and the function named in the string "f", must
% return a function value and a vector of partial derivatives. The Polack-
% Ribiere flavour of conjugate gradients is used to compute search directions,
% and a line search using quadratic and cubic polynomial approximations and the
% Wolfe-Powell stopping criteria is used together with the slope ratio method
% for guessing initial step sizes. Additionally a bunch of checks are made to
% make sure that exploration is taking place and that extrapolation will not
% be unboundedly large. The "length" gives the length of the run: if it is
% positive, it gives the maximum number of line searches, if negative its
% absolute gives the maximum allowed number of function evaluations. You can
% (optionally) give "length" a second component, which will indicate the
% reduction in function value to be expected in the first line-search (defaults
% to 1.0). The function returns when either its length is up, or if no further
% progress can be made (ie, we are at a minimum, or so close that due to
% numerical problems, we cannot get any closer). If the function terminates
% within a few iterations, it could be an indication that the function value
% and derivatives are not consistent (ie, there may be a bug in the
% implementation of your "f" function). The function returns the found
% solution "X", a vector of function values "fX" indicating the progress made
% and "i" the number of iterations (line searches or function evaluations,
% depending on the sign of "length") used.
%
% Usage: [X, fX, i] = minimize(X, f, length, P1, P2, P3, P4, P5)
%
% See also: checkgrad 
%
% Copyright (C) 2001 and 2002 by Carl Edward Rasmussen. Date 2002-02-13

% (C) Copyright 1999, 2000, 2001 & 2002, Carl Edward Rasmussen
% 
% Permission is granted for anyone to copy, use, or modify these
% programs and accompanying documents for purposes of research or
% education, provided this copyright notice is retained, and note is
% made of any changes that have been made.
% 
% These programs and documents are distributed without any warranty,
% express or implied.  As the programs were written for research
% purposes only, they have not been tested to the degree that would be
% advisable in any important application.  All use of these programs is
% entirely at the user's own risk.

RHO = 0.01;                            % a bunch of constants for line searches
SIG = 0.5;       % RHO and SIG are the constants in the Wolfe-Powell conditions
INT = 0.1;    % don't reevaluate within 0.1 of the limit of the current bracket
EXT = 3.0;                    % extrapolate maximum 3 times the current bracket
MAX = 20;                         % max 20 function evaluations per line search
RATIO = 100;                                      % maximum allowed slope ratio

argstr = [f, '(X'];                      % compose string used to call function
for i = 1:(nargin - 3)
  argstr = [argstr, ',P', int2str(i)];
end
argstr = [argstr, ')'];

if max(size(length)) == 2, red=length(2); length=length(1); else red=1; end
if length>0, S=['Linesearch']; else S=['Function evaluation']; end 

i = 0;                                            % zero the run length counter
ls_failed = 0;                             % no previous line search has failed
fX = [];
[f1 df1] = eval(argstr);                      % get function value and gradient
i = i + (length<0);                                            % count epochs?!
s = -df1;                                        % search direction is steepest
d1 = -s'*s;                                                 % this is the slope
z1 = red/(1-d1);                                  % initial step is red/(|s|+1)

while i < abs(length)                                      % while not finished
  i = i + (length>0);                                      % count iterations?!

  X0 = X; f0 = f1; df0 = df1;                   % make a copy of current values
  X = X + z1*s;                                             % begin line search
  [f2 df2] = eval(argstr);
  i = i + (length<0);                                          % count epochs?!
  d2 = df2'*s;
  f3 = f1; d3 = d1; z3 = -z1;             % initialize point 3 equal to point 1
  if length>0, M = MAX; else M = min(MAX, -length-i); end
  success = 0; limit = -1;                     % initialize quanteties
  while 1
    while ((f2 > f1+z1*RHO*d1) | (d2 > -SIG*d1)) & (M > 0) 
      limit = z1;                                         % tighten the bracket
      if f2 > f1
        z2 = z3 - (0.5*d3*z3*z3)/(d3*z3+f2-f3);                 % quadratic fit
      else
        A = 6*(f2-f3)/z3+3*(d2+d3);                                 % cubic fit
        B = 3*(f3-f2)-z3*(d3+2*d2);
        z2 = (sqrt(B*B-A*d2*z3*z3)-B)/A;       % numerical error possible - ok!
      end
      if isnan(z2) | isinf(z2)
        z2 = z3/2;                  % if we had a numerical problem then bisect
      end
      z2 = max(min(z2, INT*z3),(1-INT)*z3);  % don't accept too close to limits
      z1 = z1 + z2;                                           % update the step
      X = X + z2*s;
      [f2 df2] = eval(argstr);
      M = M - 1; i = i + (length<0);                           % count epochs?!
      d2 = df2'*s;
      z3 = z3-z2;                    % z3 is now relative to the location of z2
    end
    if f2 > f1+z1*RHO*d1 | d2 > -SIG*d1
      break;                                                % this is a failure
    elseif d2 > SIG*d1
      success = 1; break;                                             % success
    elseif M == 0
      break;                                                          % failure
    end
    A = 6*(f2-f3)/z3+3*(d2+d3);                      % make cubic extrapolation
    B = 3*(f3-f2)-z3*(d3+2*d2);
    z2 = -d2*z3*z3/(B+sqrt(B*B-A*d2*z3*z3));        % num. error possible - ok!
    if ~isreal(z2) | isnan(z2) | isinf(z2) | z2 < 0   % num prob or wrong sign?
      if limit < -0.5                               % if we have no upper limit
        z2 = z1 * (EXT-1);                 % the extrapolate the maximum amount
      else
        z2 = (limit-z1)/2;                                   % otherwise bisect
      end
    elseif (limit > -0.5) & (z2+z1 > limit)          % extraplation beyond max?
      z2 = (limit-z1)/2;                                               % bisect
    elseif (limit < -0.5) & (z2+z1 > z1*EXT)       % extrapolation beyond limit
      z2 = z1*(EXT-1.0);                           % set to extrapolation limit
    elseif z2 < -z3*INT
      z2 = -z3*INT;
    elseif (limit > -0.5) & (z2 < (limit-z1)*(1.0-INT))   % too close to limit?
      z2 = (limit-z1)*(1.0-INT);
    end
    f3 = f2; d3 = d2; z3 = -z2;                  % set point 3 equal to point 2
    z1 = z1 + z2; X = X + z2*s;                      % update current estimates
    [f2 df2] = eval(argstr);
    M = M - 1; i = i + (length<0);                             % count epochs?!
    d2 = df2'*s;
  end                                                      % end of line search

  if success                                         % if line search succeeded
    f1 = f2; fX = [fX' f1]';
    fprintf('%s %6i;  Value %4.6e\r', S, i, f1);
    s = (df2'*df2-df1'*df2)/(df1'*df1)*s - df2;      % Polack-Ribiere direction
    tmp = df1; df1 = df2; df2 = tmp;                         % swap derivatives
    d2 = df1'*s;
    if d2 > 0                                      % new slope must be negative
      s = -df1;                              % otherwise use steepest direction
      d2 = -s'*s;    
    end
    z1 = z1 * min(RATIO, d1/(d2-realmin));          % slope ratio but max RATIO
    d1 = d2;
    ls_failed = 0;                              % this line search did not fail
  else
    X = X0; f1 = f0; df1 = df0;  % restore point from before failed line search
    if ls_failed | i > abs(length)          % line search failed twice in a row
      break;                             % or we ran out of time, so we give up
    end
    tmp = df1; df1 = df2; df2 = tmp;                         % swap derivatives
    s = -df1;                                                    % try steepest
    d1 = -s'*s;
    z1 = 1/(1-d1);                     
    ls_failed = 1;                                    % this line search failed
  end
end
fprintf('\n');


	


	

	

