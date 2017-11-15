function [retDat,algo] =  training(algo,retDat)
%[retDat,algo] =  training(algo,retDat)
% Train an lin_norm preprocessor.
% Inputs:
% algo -- A "lin_norm" classifier object.
% retDat -- A training data object.
% Returns:
% retDat -- Preprocessed data.
% algo -- The parameters of the preprocessing.

% Isabelle Guyon -- Apr 2013 -- isabelle@clopinet.com

if algo.algorithm.verbosity>0
    disp(['training ' get_name(algo) '... '])
end

X=get_x(retDat);
y=get_y(retDat);
[p, n]=size(X);
XX=zeros(size(X));

for k=1:n
    %R=corrcoef(X(:,k),y);
    %C=R(1,2);
    %S=1;
    %if ~isnan(C)
    %    S=sign(C);
    %end
    x=[X(:,k), ones(p,1)];
    w=pinv(x'*x)*x'*y;
%    w=x\y;
    %algo.W(k)=S*w(1);
    %algo.b(k)=S*w(2);
    % The idea of flipping genes does not work because the stitching offset
    % is then wrong
    algo.W(k)=w(1);
    algo.b(k)=w(2);
end

retDat=test(algo,retDat);

        








