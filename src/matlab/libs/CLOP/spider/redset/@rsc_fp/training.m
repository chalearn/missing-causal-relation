function [d, a] =  training(a,d)
  
 
  if a.algorithm.verbosity>0
    disp(['calculating reduced set vectors by fixpoint method for ', get_name(a.child)])
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
  dim = size(get_x(Xsv),2);
  a.child.Xsv = Xsv;
  a.child.alpha = alpha;
  k = a.child.child;
  K = calc(k,Xsv);
  stv=a.stv;
  
  % seperate two classes
  XSVp = get_x(Xsv,alpha>0);
  XSVm = get_x(Xsv,alpha<0);
  
  % calculate desired # of rsvs
  if a.rsv < 1
      a.rsv = ceil(sum(abs(alpha)>0) * a.rsv);
  end;
  
  disp(['compressing for ', num2str(a.rsv) , ' rsvs']);

  nm_sq = alpha' * K * alpha;
  dw(1) = nm_sq;

  gamma = [];
  z = [];
  Kzz= [];
  
for i = 1:a.rsv
  disp(['calculating rsv ', num2str(i)]);
  
  % set sum(alpha_i*phi(x_i)) - sum(beta_i*z_i)
  beta = [alpha; -gamma];
  y = [get_x(Xsv); z];
  
  tmp_z = {};
  tmp_g = {};  
  % loop for trying different starting values
  for  st = 1:stv
    unique = 0;
    uc = 0; 
    while unique ~= 1
     % init
     % search alternating for positive and negative examples
     % if a not unique vector is found, search in other class first
     %if mod(i+uc,2)==1  %|| mod(i+uc,2)==0 % use only when all alpha > 0 !
      if 1
       index = ceil(rand(1)*size(XSVp,1));
       z_new = XSVp(index,:);
     else
       index = ceil(rand(1)*size(XSVm,1));
       z_new = XSVm(index,:);
       beta = -beta;
     end;
     z_old = zeros(1,dim);
    
     % do fixpoint iteration
     restarts = 0;
     j = 1;
     norm_old = 0;
     while  norm(z_old-z_new) > a.eps*100 & abs(norm_old - norm(z_old-z_new)) > a.eps & j <1000
       norm_old =  norm(z_old-z_new);
       z_old = z_new;
       % fixpoint equation here
       fnum = fpfn(z_old, beta, y, kerparam);
       fden = fpfd(z_old, beta, y, kerparam);
       z_new = fnum/fden;
       
       % checks for numerical stability
       % check if denominator is approaching zero --> restart
       if fden < a.eps
         %z_new = rand(1,dim) * range - .5*range;
         if mod(i+uc,2)==1  %|| mod(i+uc,2)==0 % use only when all alpha > 0 !
           index = ceil(rand(1)*size(XSVp,1));
           z_new = XSVp(index,:);
         else
          index = ceil(rand(1)*size(XSVm,1));
          z_new = XSVm(index,:);
          beta = -beta;
         end;
         restarts = restarts + 1;
         if restarts == a.max_it
           disp('maximum number of restarts...');
	       if mod(i+uc,2)==1
 	         index = ceil(rand(1)*size(XSVm,1));
         	 beta = -beta;
	       else
	         index = ceil(rand(1)*size(XSVp,1));
             beta = -beta;
	       end;
         elseif restarts == 2*a.max_it
           disp('WARNING: 2 times maximum number of restarts... result may be inaccurate.');
	       break;
         end;
       end;
       j = j + 1;
     end;
     
     if j == 1000
         disp('no convergence reached with max iteration = 1000!')
     end;
     
     if restarts ~= 0 
      disp([num2str(restarts), ' restarts were necessary']);
     end;
  
     % check is rsv is already in set
     if i ~= 1
       unique = checku(z_new, z);
       if unique~=1
        disp('not unique rsv found... restarting iteration.');
       end;
       uc = uc+1;
       if uc == a.max_it
        disp('maximum number of not unique iterations...')
        break;
       end;
     else
       unique = 1;
     end;
    end;
  
    tmp_z{st} = [z; z_new];
    tmp_gamma{st} = [gamma; 0];
    
    % recalculate all gammas
    if i==1
      tmp_gamma{st} = calc(k, Xsv, data(tmp_z{st}))*alpha;
    else
      tmp_gamma{st} = minres(calc(k, data(tmp_z{st})),calc(k, Xsv, data(tmp_z{st})) * alpha);
    end;
   end;
  
   % find best starting value (that minimizes most)
   stv_dw = [];
   for id = 1:a.stv
     curr_z = tmp_z{id};
     curr_gamma = tmp_gamma{id};
     stv_dw(id) = fz(curr_z(size(curr_z,1),:)', a.child, curr_z, curr_gamma,nm_sq,k);
   end;
   [m index] = min(stv_dw);
   % set z and gamma to best values
   z = tmp_z{index};
   gamma = tmp_gamma{index};

   dw(i+1) = fz(z(size(z,1),:)', a.child, z, gamma,nm_sq,k);
  
   disp('-----------------------------')
   disp('fixpoint interation stats')
   disp(['target value before: ' num2str(dw(i))]);
   disp(['target value after: ' num2str(dw(i+1))]);
   disp(['decrease: ' num2str(dw(i)-dw(i+1))]);
   disp('-----------------------------')
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
disp('stats for reduced set contruction with fixpoint method')
disp('------------------------------------------------------')
disp(['original support vectors: ' num2str(sum(abs(alpha)>0))]);
disp(['reduced set vectors found: ' num2str(a.rsv)]);
disp(['decrease in ||w-w*||^2: ' num2str(a.delta_w)]);
disp(['final value of ||w-w*||^2: ' num2str(a.w2)]);
disp('------------------------------------------------------')

  
  
  
  d = test(a,d);
  
  
% subfunction fpfn
function ret = fpfn(z, B, Y, s)
dim = size(z,2);

ret =  B' * diag(calc(kernel('rbf',s),data(z),data(Y))) *Y;
% 
% 
% ret2 = zeros(1,dim);
% for i = 1:size(B,1)
%  e = exp(-(norm(Y(i,:) - z)^2)/(2*s^2));
%  ret2 = ret + B(i) * e * Y(i,:);
% end
% ret - ret2

% subfunction fpfd
function ret = fpfd(z, B, Y, s)

K = calc(kernel('rbf',s),data(z),data(Y));
ret = B'*K;

%  ret2=0;
%  for i = 1:size(B,1)
%   e = exp(-(norm(Y(i,:) - z)^2)/(2*s^2));
%   ret2 = ret2 + B(i) * e; 
%  end
%  
%  ret-ret2

% subfunction checku
function ret = checku(z, Z)
% normalizes the reduced set vectors and calculates angle between them
% if angle is small, vectors are considered to be identical, and 1 is
% returned
for i=1:size(Z,1)
 Z(i,:) = Z(i,:) / norm(Z(i,:));
end;
z = z / norm(z); 
S = Z * z';
E = ones(size(S,1),1);
T = E - S;
S = abs(T)<1e-5;
ret = (sum(S) == 0);

% subfunction fz
function ret = fz(x0, a, Z, G,nm_sq,k)
% returns value of target function ||w-w*||^2
x0 = x0';
Z(size(Z,1), :) = x0;
ret = nm_sq + G' * calc(k, data(Z)) * G - 2 * a.alpha' * calc(k, data(Z), a.Xsv) * G;
