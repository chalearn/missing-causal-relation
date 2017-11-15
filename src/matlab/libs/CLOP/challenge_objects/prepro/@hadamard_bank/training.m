function [retDat,algo] =  training(algo,retDat)
%[retDat,algo] =  training(algo,retDat)
% Train a hadamard bank.
% Inputs:
% algo -- A data object to be "trained".
% retDat -- A training data object.
% Returns:
% retDat -- No data modification.
% algo -- The trained filter bank.

% Isabelle Guyon -- November 2005 -- isabelle@clopinet.com

% Get a filter bank of the right size
[p,n]=get_dim(retDat);
[kp,kn]=size(algo.data.X);
if n~=kn
    d=num2str(sqrt(n)); % square image assumed
    if round(d)~=d,
        error('match_filter: Can handle only square images');
    end
    algo=feval(class(algo), {['dim1=', d], ['dim2=', d]});
end


        








