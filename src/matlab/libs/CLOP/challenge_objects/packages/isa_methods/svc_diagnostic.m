function [sv,msv,vcdim] = svc_diagnostic(alpha,C,KD2_max,log,silent)
%[sv,msv,vcdim] = svc_diagnostic(alpha,C,KD2_max,log,silent)
% Inputs: alpha -- Vector of p coefficients, p=number of training patterns.
%         C -- Soft margin parameter.
%			 KD2_max -- Largest squared distance between training patterns 
%                    in the kernel metric.
% Optional: log -- FID of a log file (1: stdout, 1: stderr)
%           debug -- Debug flag: 0 or 1.
% Returns: sv -- Indices of the support vectors.
%			  msv -- Indices of the marginal support vectors.
%          vcdim -- A quantity measuring the complexity of the solution: KD2_max/margin^2.

% Isabelle Guyon - September 1999 -

if(nargin<4), log=2; end
if(nargin<5), silent=0; end

p=length(alpha);
% Support vector detection threshold
epsilon = 0.01*max(max(alpha))/p;
% Support vectors:
sv = find(alpha > epsilon);
% Coefficients of the support vectors
sv_alpha = alpha(sv);

%if(debug==1),
%	w2=sv_alpha'*H(sv,sv)*sv_alpha; 
%   fprintf(log, '|w|^2 = alpha'' H alpha = %f\n',w2); % w = direct space weight vector.
%end
w2=sum(sv_alpha);
if ~silent, fprintf(log, '|w|^2 = sum alpha = %f\n',w2); end
margin = 1/sqrt(w2);
if ~silent, fprintf(log, 'Margin = 1/|w| = %f\n',margin); end
vcdim = KD2_max*w2;
if ~silent,
    fprintf(log, 'VC dimension = KDmax^2 * |w|^2 = %f\n',vcdim);
    fprintf(log, 'Rescaled margin = 1/sqrt(vcdim) = %f\n',1/sqrt(vcdim));
end
m = length(sv);
if ~silent, fprintf(log, 'Number of support vectors : %d (%3.1f%% total number of patterns).\n',m,100*m/p); end

% Marginal support vectors:
msv = find( alpha > epsilon & alpha < (C - epsilon));
mm = length(msv);
if ~silent, fprintf(log, 'of which %d marginal and %d non marginal support vectors.\n',mm,m-mm); end

if(length(sv)<10 & ~silent)
   fprintf(log,'Support vectors:\n');
   fprintf(log,'%d ', sv);
   fprintf(log,'\nMarginal support vectors:\n');
  	fprintf(log,'%d ', msv);
   fprintf(log,'\n');
end
