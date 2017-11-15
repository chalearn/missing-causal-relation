function [Alpha, B, kernel, q, gamma, C, Vcdim, sv, msv] = ...
   svc_train(X,Y,kernel,q,gamma0,C,xi,debug,XX,Euclid2,K,KD2_max,log,Alpha0,silent,coef0)
%[Alpha, B, kernel, q, gamma, C, Vcdim, sv, msv] = ...
%  svc_train(X,Y,kernel,q,gamma0,C,xi,debug,XX,Euclid2,K,KD2_max,log,Alpha0,silent,coef0)
% Train a support vector classifier by minimizing the functional
% (1/2) alpha' H alpha + (-1)' alpha
% under the constraints:
% Y' alpha = 0 and 0 <= alpha <= C
% to build the classifier D(x) = sum_k alpha_k y_k svc_dp(x, x_k).
% Inputs:  X --  2d matrix X of row training vectors.
%                [p,n]=size(X);
%                p number of training patterns, n size of input space.
%          Y --  Vector(s) of class training target values +1 or -1.
%                For the multiclass problem [p,c]=size(Y);
%                p number of training patterns, c number of classes.
% Optional parameters:
%          kernel -- Name of the dot product kernel function    
%                    (e.g. 'linear', 'polynomial' for a list type help svc_dp).
%          q -- Degree of polynomial in kernel function.
%          gamma0 -- Locality parameter in kernel function. If Euclid2 is not provided,
%                   it is assumed that gamma has not been rescaled. It is then
%                   replaced by gamma0/max(max(Euclid2)) by svc_prepare or by a local gamma.
%          C -- Soft-margin constant (default Inf: no effect).
%          xi -- Diagonal term added to Hessian (default 0, no effect).
%          debug -- If 1, print debug code.
%          XX,Euclid2,K,KD2_max -- Outputs of svc_prepare.
%		   log -- FID of log file (1: stdout, 2:stderr)
%		   Alpha0 -- Starting point.
%          silent -- 0/1 flag to eleminate verbose mode
%          coef0 -- kerl bias (see help svc_dp)
% Returns: Alpha -- Support vector coefficients (length p, zero for non supp. vec.).
%                For the multiclass problem [p,c]=size(Alpha);
%                p number of training patterns, c number of classes.
%          B --  Bias. For the multiclass problem, a length c vector.
%			  kernel -- Name of the dot product kernel function used.
%          q -- Degree of polynomial in kernel function.
%          gamma -- Rescaled locality parameter (with maximum distance between patterns).
%          C -- Rescaled soft-margin constant (with largest eigen value of Hessian).
%          Vcdim -- Inverse margin size rescaled by the diameter of the data.
%                   For the multiclass problem, a length c vector.
%          sv -- support vector indices
%          msv -- marginal support vector indices

% Isabelle Guyon - August 1999 - 

if (nargin <2) help svc_train; error('Bad number of arguments.'); end
if (nargin <3 || isempty(kernel)) kernel = 'general'; end
if (nargin <4 || isempty(q)) q =2; end 
if (nargin <5 || isempty(gamma0)) gamma0 =1; end 
if (nargin <6 || isempty(C)) C=Inf; end
if (nargin <7 || isempty(xi)) xi=0; end
if (nargin <8 || isempty(debug)) debug=0; end
if (nargin <9) XX=[];Euclid2=[];K=[];KD2_max=Inf; end
if (nargin <13) log=2; end
if (nargin <14) Alpha0=[]; end
if (nargin <15) silent=0; end
if (nargin <16) coef0=0; end

if silent, warning off; end
local_gamma=0;
gamma=gamma0;

% Dimensioning the outputs:
[p,n] = size(X);
[pp,c] = size(Y);
if(p~=pp), help svc_train; error('Input dimension mismatch'); end
Alpha = zeros(p,c);
B = zeros(1,c);
Vcdim = zeros(1,c);

% Computing all the Euclidean distances and dot products:
if(isempty(XX))
   [XX,Euclid2,K,kernel,q,gamma,KD2_max] = svc_prepare(X,kernel,q,gamma0,XX,Euclid2,1,silent,coef0);
end

%fprintf('Adjusting soft-margin parameter scale...\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%if(C~=Inf),
% 	K_max = max(max(abs(K)));
%	fprintf('Largest abs(K): K_max=%f\n', K_max);
%	C = C/K_max;
%   fprintf('Rescaled soft-margin parameter: C=%f\n', C);
%end

if ~silent, fprintf('Setting the optimization parameters...\n'); end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lb = zeros(p,1);        % Lower bound: alpha >= 0
ub = repmat(C,p,1);     % Upper bound: alpha <= C
% Vector used in the linear term of the cost function
ff = -ones(p,1);         % Linear term: (-1)' alpha

the_time=zeros(c,1);
% Loop over all classes
for i=1:c,
   if ~silent, 
       fprintf('\nTraining classifier for class %d\n',i); 
       fprintf('--------------------------------\n',i);
	   fprintf('Computing the Hessian...\n');
   end
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   y = Y(:,i);
   
   if(local_gamma)
   	if ~silent, fprintf('Adjusting gamma according to median(sqrt(min(Euclid2(y<0,y>0))))...\n'); end
   	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   	% Adjustment of gamma according to the median of the distances between
   	% positive examples and their nearest negative example (see Brown et al)
   	sigma=median(sqrt(min(Euclid2(y<0,y>0))));
   	gamma=gamma0/sigma;
   	if ~silent, fprintf('Re-computing the dot products...\n'); end
   	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   	[XX,Euclid2,K,kernel,q,gamma1,KD2_max] = svc_prepare(X,kernel,q,gamma,XX,Euclid2,[],silent,coef0);
      if(gamma1~=gamma) warning('Gamma was rescaled by error'); end
      if ~silent, fprintf(log, 'Effective locality parameter used: gamma=%f\n', gamma); end
   end
   % Setting signs
	H = (y*y') .* K;
   
   % Hessian regularization:
	if(xi==0),
   	if ~silent, disp('Using pd_check routine of A.J. Quist of TWI-SSOR.'); end
   	if (pd_check(H) ~= 1)
      	ii = -50;
      	while (pd_check (H + (10.0^ii)*eye(p)) ~= 1)
        		ii = ii + 1;
      	end
      	xi = (10.0^(ii));
      end
   else
      % Rescale xi with Hmax(=K_max)
      % xi = xi*K_max;
   end
   %H=H+xi*eye(p);
   %fprintf (log, 'Adding %g to Hessian diagonal\n', xi);
   %if(1==2)
   sy = sum(y); a_neg = (p-sy)/(2*p); a_pos = (p+sy)/(2*p);
   if(a_neg < a_pos) xi_neg = xi; xi_pos = a_pos/a_neg*xi;
   else xi_pos = xi; xi_neg = a_neg/a_pos*xi; end
   if ~silent, 
       fprintf (log, 'Adding %g to Hessian diagonal for negative ex. and %g for positive ex.\n', ...
      xi_neg, xi_pos);
   end
   xi_vec = zeros(p,1);
   xi_vec(y<0) = xi_neg;
   xi_vec(y>0) = xi_pos;
   H = real(H + diag(xi_vec)); 
   %end
	if ~silent, fprintf('Minimizing the cost function...\n'); end
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Linear equality constraint:
   if (strcmp(lower(kernel),'linear')),
    	AA = y'; BB = 0;      % Set the bias constraint to Y' alpha = 0
	else
    	AA = []; BB = [];     % No bias constraint
	end
	if(debug==1) H,ff,AA,BB,lb,ub, end;
	tic;
    if silent
        options=optimset('Diagnostics', 'off','Display', 'off');
    else
        options=optimset('Diagnostics', 'on','Display', 'on');
    end
   [alpha,opt_val,exitflag,output,lambda]=quadprog(H,ff,[],[],AA,BB,lb,ub,Alpha0,options);
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   if ~silent, the_time(i)=toc, end
   if(debug==1) alpha,opt_val,exitflag,output,lambda, end

	% Computing the bias and displaying the results
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   [sv,msv,vcdim] = svc_diagnostic(alpha,C,KD2_max,log,silent);
   % Bias value:
   b = 0; 								% Implicit bias if 1 is added to the feature vector
   mm = length(msv);
   if(mm > 0), 
   		b =  (1/mm) * sum( y(msv) - H(msv,sv)*alpha(sv).*y(msv) );
   else 
   		if ~silent, fprintf('No support vectors on margin - cannot compute bias.\n'); end
   end 
   Alpha(:,i)=alpha;
   B(i)=b;
   Vcdim(i)=vcdim;

end % loop over classes  
if ~silent, fprintf('\nNumber of patterns %d. Number of classes %d\n', p, c); end
if ~silent, fprintf('Time = %g +- %g\n', mean(the_time), std(the_time)); end
warning on
