function [retDat,algo] =  training(algo,retDat)
%[retDat,algo] =  training(algo,retDat)
% Train a subsampling method.
% Inputs:
% algo -- A subsampling object.
% retDat -- A training data object.
% Returns:
% retDat -- The same data structure, but X and Y are replaced by matrices restricted
%           to fewer training examples.
% algo -- The trained subsampling object, i.e. pidx is set to the chosen patterns.

% Isabelle Guyon -- September 2005 -- isabelle@clopinet.com

if algo.algorithm.verbosity>0
    disp(['training ' get_name(algo) '... '])
end

[p,n]=get_dim(retDat);

if algo.p_max>p, algo.p_max=p; end

% Don't train if pidx is already defined
if ~isempty(algo.pidx)
    algo.p_max=length(algo.pidx);
    return
end

% Set p_max if it is not defined:
if isempty(algo.p_max) | algo.p_max==Inf
    if ~isempty(algo.pidx)
        algo.p_max=length(algo.pidx);
    else
        algo.p_max=p;
        algo.pidx=1:n;
        return
    end
end

X=get_x(retDat); 
Y=get_y(retDat); 

% Draw indices at random:
if isempty(algo.pidx)
    if algo.balance
        pidx=find(Y>0);
        nidx=find(Y<0);
        rpidx=randperm(length(pidx));
        rnidx=randperm(length(nidx));
        pidx=pidx(rpidx);
        nidx=nidx(rnidx);
        pnum=min(round(algo.p_max/2), length(pidx));
        nnum=min(algo.p_max-pnum, length(nidx));
        algo.pidx=[pidx(1:pnum); nidx(1:nnum)];
        ridx=randperm(length(algo.pidx));
        algo.pidx=algo.pidx(ridx);
    else    
        ridx=randperm(p);
        algo.pidx=ridx(1:algo.p_max);
    end
end

% Restrict the data:
retDat=set_x(retDat, X(algo.pidx,:)); 
retDat=set_y(retDat, Y(algo.pidx,:)); 
        
retDat=set_name(retDat,[get_name(retDat) ' -> ' get_name(algo)]); 






