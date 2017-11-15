function [XX,Euclid2,K,kernel,q,gamma,KD2_max] = svc_prepare(X,kernel,q,gamma,XX,Euclid2,rescale,silent,coef0)
%[XX,Euclid2,K,kernel,q,gamma,KD2_max] = svc_prepare(X,kernel,q,gamma,XX,Euclid2,rescale,silent,coef0)
% Prepare for training an SVC classifier
% by computing all the distances between patterns and the dot products.
% Inputs:  X --  2d matrix X of row input vectors.
%                [p,n]=size(X);
%                p number of training patterns, n size of input space.
%          kernel -- Name of the dot product kernel function    
%                    (e.g. 'linear', 'polynomial' for a list type help svc_dp).
%          q -- Degree of polynomial in kernel function.
%          gamma -- Locality parameter in kernel function.
% Optional inputs (if already computed):
%			  XX -- Outer product X*X'.
%			  Euclid2 -- Square distances between patterns.
%          rescale -- if 1, rescale gamma with the max Euclid dist between patterns.
%          silent -- 0/1 flag to eleminate verbose mode
%          coef0 -- kerl bias (see help svc_dp)
% Returns: XX -- Outer product X*X'.
%			  Euclid2 -- Square distances between patterns.
%          K --  Dot products computed with the kernel function.
%          kernel -- Name of the dot product kernel function used.
%          q -- Degree of polynomial in kernel function used.
%          gamma -- Rescaled locality parameter (with maximum distance between patterns).
%			  KD2_max -- Maximum squared distance between patterns in the K metric.

% Isabelle Guyon - August 1999 - Add coef0 feb 2015

if (nargin <1) help svc_train; error('Bad number of arguments.'); end
if (nargin <2 || isempty(kernel)) kernel = 'general'; end
if (nargin <3 || isempty(q)) q =2; end 
if (nargin <4 || isempty(gamma)) gamma =1; end 
if (nargin <5 || isempty(XX)) XX=[]; end 
if (nargin <6 || isempty(Euclid2)) Euclid2=[]; end 
if (nargin <7 || isempty(rescale)) rescale=0; end
if (nargin <8 || isempty(silent)), silent=0; end
if nargin<9, coef0=0; end

[p,n] = size(X);
if ~silent, fprintf('Computing X*X''...\n'); end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(isempty(XX)) XX = X*X'; end
if ~silent, fprintf('Computing Euclid2...\n'); end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(isempty(Euclid2)) Euclid2 = svc_dp('euclid2',X,X,[],[],[],[],coef0); end 
if(rescale)
	if ~silent, fprintf('Adjusting local parameter scale...\n'); end
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	D2_max = max(max(Euclid2));
	if ~silent, fprintf('Largest distance between patterns: D_max=%f\n', sqrt(full(D2_max))); end
	gamma = gamma/D2_max;
	if ~silent, fprintf('Rescaled locality parameter: gamma=%f\n', gamma); end
end
if ~silent, fprintf('Computing the dot products...\n'); end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
K = svc_dp(kernel, X, X, q, gamma, XX, Euclid2, coef0); % Passing XX and Euclid2 saves computations.

if ~silent, fprintf('Computing the maximum distance between patterns in the K metric...\n'); end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Kuu = repmat(diag(K),1,size(K,1));
KD2 = Kuu - 2 * K + Kuu';
KD2_max = max(max(KD2));
if ~silent, fprintf('Largest distance between patterns in the K metric: KD_max=%f\n', sqrt(KD2_max)); end
