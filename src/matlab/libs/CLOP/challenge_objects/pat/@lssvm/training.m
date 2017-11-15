function [retDat,algo] =  training(algo,retDat)
%[retDat,algo] =  training(algo,retDat)
% Train a least square support vector classifier.
% kernels supported for the challenge:
%    linear                             k(x,y)=x.y
%    poly                poly degree d, k(x,y)=(x.y+1)^d
%    rbf                 sigma,         k(x,y)=exp(-|x-y|^2/(2*sigma^2))
%    poly_rbf            const, degree d, gamma
%                        k(x,y)=(x.y+const)^d exp(-gamma|x-y|^2)*sigma^2))
% Note: poly_rbf includes all the other kernels for special values
%       of the kernel parameters.
% Inputs:
% algo -- A svc classifier object.
% retDat -- A training data object.
% Returns:
% retDat -- The same data structure, but X is replaced by the class label
% predictions on training data.
% algo -- The trained svc classifier.

% Isabelle Guyon -- September 2006 -- isabelle@clopinet.com

if algo.algorithm.verbosity>0
    disp(['training ' get_name(algo) '... '])
end

opt=algo.optimizer;
[p,n]=get_dim(retDat);

switch opt
    case 'fminunc'
        % Note: algo can be an object or a plain structure.
        [retDat, algo]=lssvm_demo(algo, retDat);
        algo.Xsv=data(algo.Xsv);
    otherwise
        disp 'Wrong option'
end

% Backward compatibility with existing spider kernels
if algo.gamma==0 & algo.degree==1 & algo.coef0==0
    algo.child=kernel('linear');
    algo.W=algo.alpha'*algo.Xsv.X;
    algo.Xsv=[]; % Save memory
elseif algo.gamma==0 & algo.degree==1 
    algo.child=kernel('linear_with_bias', algo.coef0);
    algo.W=algo.alpha'*algo.Xsv.X;
    algo.Xsv=[]; % Save memory
elseif algo.gamma==0 & algo.coef0==1
    algo.child=kernel('poly', algo.degree);
elseif algo.gamma==0 
    algo.child=kernel('poly_with_bias', [algo.coef0, algo.degree]);
elseif algo.degree==0
    p=[];
    if algo.gamma==0, p=Inf; end
    if algo.gamma==Inf, p=0; end
    if isempty(p) p=sqrt(1/(2*algo.gamma)); end
    algo.child=kernel('rbf', p); % Note here the parameter is the kernel witdh
else
    algo.child=kernel('poly_rbf', [algo.coef0, algo.degree, algo.gamma]);
end

 