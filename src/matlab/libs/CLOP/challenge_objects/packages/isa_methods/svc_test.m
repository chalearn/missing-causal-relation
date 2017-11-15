function [Output, errate, fnrate, fprate, mcrate, Error_idx, Fn_idx, Fp_idx] = ...
   svc_test(train_X,train_Y,alpha,b,kernel,q,gamma,test_X,test_Y,theta1,theta2,show_fafr,log, silent)
%[Output, errate, fnrate, fprate, mcrate, Error_idx, Fn_idx, Fp_idx] = ...
%  svc_test(train_X,train_Y,alpha,b,kernel,q,gamma,test_X,test_Y,theta1,theta2,show_fafr,log, silent)
% Test a support vector classifier
% Inputs:  train_X --  Training 2d matrix X of row input vectors.
%                      [p,n]=size(X);
%                      p number of training patterns, n size of input space.
%          train_Y --  Training vector(s) of class target values +1 or -1.
%                      For the multiclass problem [p,c]=size(Y);
%                      p number of training patterns, c number of classes.
%			  alpha   --  Matrix of support vector coefficients.
%                      [p,c]=size(alpha);
%          b       --  Bias.
%          kernel  --  Name of the dot product kernel function    
%                      (e.g. 'linear', 'polynomial' for a list type help svc_dp).
%          q       --  Degree of polynomial in kernel function.
%          gamma   --  Locality parameter in kernel function.
%			  test_X  --  Test 2d matrix X of row input vectors.
%                      [tp,n]=size(test_X);
% Optional:
%          test_Y  --  Test vector of class target values +1 or -1.
%          theta1  --  Absolute rejection threshold.
%          theta2  --  Relative rejection threshold.%
%			  show_fafr -- flag: 0=nothing, 1=show false accpeted/false rejected curves
%			  log 	 -- FID of log file (1: stdout, 2:stderr)
% Returns:
%			  Output  --  Outputs of the discriminant functions (before thresholding).
%                      [tp,c]=size(Output)
%          errate  --  Error rate, if the target vector is precised.
% 			  fnrate -- false negative (rejected) fraction of errors
% 			  fprate -- false positive (accepted) fraction of errors
%			  mcrate -- misclassified fraction of errors
%          Error_idx -- Indices of the errors, if the target vector is precised.
%          Fn_idx -- Indices of false negative (rejected), if the target vector is precised.
%          Fp_idx -- Indices of false positive (accepted), if the target vector is precised.

% Size verification
[p,n]=size(train_X);
[pp,c]=size(train_Y);
[ppp,cc]=size(alpha);
if(pp~=p | pp~=ppp | c~=cc) help svc_test; error('Input matrix size mismatch'); end
[tp,n]=size(test_X);
if(nargin>8) & ~isempty(test_Y), 
   [tpp,ccc]=size(test_Y);
   if(tpp~=tp | c~=ccc) help svc_test; error('Test matrix size mismatch'); end
else
   test_Y=[];
end
if(nargin<10) | isempty(theta1), theta1=0; end
if(nargin<11) | isempty(theta2), theta2=0.5; end
if(nargin<12 | isempty(show_fafr)), show_fafr=0; end
if(nargin<13)| isempty(log), log=1; end
if(nargin<14), silent=0; end

% Dimension the output matrix (Discriminant function values)
Output = zeros(tp,c);

% Support vector detection threshold
epsilon = 0.01*max(max(alpha))/p;
% Compute all the relevant dot products (to avoid computing them multiple times)
sum_alpha = alpha * ones(c,1);
all_sv_idx = find(sum_alpha > epsilon); % all support patterns for all classes
if ~silent, fprintf(log, 'Total number of support patterns %d\n',length(all_sv_idx)); end
all_sv_X = train_X(all_sv_idx,:);
DP = svc_dp(kernel,all_sv_X,test_X,q,gamma);
% Invert the index map
DP_idx = zeros(p,1);
DP_idx(all_sv_idx) = 1:length(all_sv_idx);

% Loop over classes
for i=1:c,
	% Support vector indices:
	sv_idx = find(alpha(:,i) > epsilon);
	% Coefficients of the support vectors:
   sv_alpha = alpha(sv_idx,i);
   % Target values of the support vectors:
   sv_Y = train_Y(sv_idx,i);
   % Dot products for the support vectors of this class:
   DP_i = DP(DP_idx(sv_idx),:);
   % Discriminant function values:
   Output(:,i) = DP_i'*(sv_Y.*sv_alpha);
end
% Add the biases
Output = Output + repmat(b,tp,1);
% Take real part because of rounding errors
Output = real(Output);
% Error rate
if(~isempty(test_Y)),
   [errate, fnrate, fprate, mcrate, Error_idx, Fn_idx, Fp_idx] = svc_stat(Output, test_Y, theta1, theta2, show_fafr);
else
   errate = 0; fnrate = 0; fprate = 0; mcrate = 0;
   Error_idx=[]; Fn_idx=[]; Fp_idx=[];
end


