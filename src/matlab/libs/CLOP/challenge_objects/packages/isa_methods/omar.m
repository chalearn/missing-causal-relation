function [W,b] = omar(X,Y,C,xi,logfile)
%[W,b] = omar(X,Y,C,xi)
% Linear optimum margin classifier
% Inputs 

% Isabelle Guyon -- April 2000 -- isabelle@clopinet.com

kernel = 'linear';
q=1;
gamma=0;
if(nargin<3) C=Inf; end			 % Soft margin parameter
if(nargin<4) xi = 0.001; end         % Regularization of Hessian
if(nargin<5) logfile=1; end

warning('off');
silent=1;
% Add a constant feature one (this fixes the problem of absence of marginal
% support vectors.)
X=[ones(size(X,1),1),X];
% Train
[Alpha, b] = svc_train(X,Y,kernel,q,gamma,C,xi,[],[],[],[],[],logfile,[],silent);
W = (Y.*Alpha)'*X;
% Modify the weight and bias
b=W(1)+b;
W=W(2:length(W));
warning('on');
