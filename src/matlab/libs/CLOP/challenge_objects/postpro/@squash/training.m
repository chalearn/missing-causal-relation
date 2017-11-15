function [retDat,algo] =  training(algo,retDat)
%[retDat,algo] =  training(algo,retDat)
% Train a Squash postprocessor.
% Inputs:
% algo -- A Squash classifier object.
% retDat -- A training data object.
% Returns:
% retDat -- The same data structure, but X is replaced by the class label
% predictions on training data.
% algo -- The "trained" bias.

% Isabelle Guyon -- April 2013 -- isabelle@clopinet.com

if algo.algorithm.verbosity>0
    disp(['training ' get_name(algo) '... '])
end

debug_me=0;

x=get_x(retDat); 
if size(x, 2)>1
    error('Implemented for unidimensional data only');
end
y=get_y(retDat); 
[p,n]=size(x);
if length(x)~=p
    error('Incompatible dimensions');
end

vy=var(y, 1);

w=randn;
b=-mean(x)*randn;
s=max(algo.smin, 0.5*abs(max(y)-min(y)));
y0=mean(y);

eta=algo.eta;
gamma=algo.gamma;
if debug_me, h=figure; end
df=Inf;
r2=Inf;

j=1;
W=[];
B=[];
S=[];
Y=[];
r2_min=Inf;

if debug_me
    fprintf('Iter=%d, s=%5.2f, y0=%5.2f, w=%5.2f, b=%5.2f, df=%5.2g, r2=%5.2g\n', 0, s, y0, w, b);
end

for k=1:algo.maxiter

    % randomize the order of the examples
    rp=randperm(p);
    x=x(rp);
    y=y(rp);
    % loop over the examples
    wold=w;
   	bold=b;
    y0old=y0;
    sold=s;
    for i=1:p
        yhat=s*tanh(w*x(i)+b)+y0;
        e(i)=(y(i)-yhat);
        dy0=2*eta*e(i);
        ds=tanh(w*x(i)+b)*dy0;
        db=2*eta*s*(1-(tanh(w*x(i)+b))^2)*e(i);
        dw=x(i)*db;
        w=(1-gamma)*(w+dw) + gamma*w;
        b=(1-gamma)*(b+db) + gamma*b;
        y0=(1-gamma)*(y0+dy0) + gamma*y0;
        s=(1-gamma)*(s+ds) + gamma*s;
        s=max(abs(s), algo.smin);
    end
    
    algo.W=w;
    algo.b0=b;
    algo.s=s;
    algo.y0=y0;
    
    if debug_me && ~mod(k, 10) 
        plot(algo, retDat, h);
        fprintf('Iter=%d, s=%5.2f, y0=%5.2f, w=%5.2f, b=%5.2f, df=%5.2g, r2=%5.2g\n', k, algo.s, algo.y0, algo.W, algo.b0, df, r2);
    end
    
    df=max([abs(w-wold)/abs(w+eps), abs(b-bold)/abs(b+eps), abs(y0-y0old)/abs(y0+eps), abs(s-sold)/abs(s+eps)]);
    r2=mean(e.^2)/vy;
    if r2<r2_min % pocket the results
        r2_min=r2;
        W=w;
        B=b;
        S=s;
        Y=y0;
    end
        
    if r2<algo.tol || (r2<10*algo.tol && abs(df)<algo.diff/10)
        if debug_me
            plot(algo, retDat, h);
            fprintf('Iter=%d, s=%5.2f, y0=%5.2f, w=%5.2f, b=%5.2f, df=%5.2g, r2=%5.2g\n', k, algo.s, algo.y0, algo.W, algo.b0, df, r2);
        end
        break, 
    end
    
    if abs(df)<algo.diff && ~mod(k, 1000)
        if debug_me, fprintf('Reinit\n'); end
        w=randn;
        b=-mean(x)*randn;
        s=max(algo.smin, 0.5*abs(max(y)-min(y)));
        y0=randn*mean(y);
        j=j+1;
        algo.W=w;
        algo.b0=b;
        algo.s=s;
        algo.y0=y0;
        if debug_me
            fprintf('Iter=%d, s=%5.2f, y0=%5.2f, w=%5.2f, b=%5.2f, df=%5.2g, r2=%5.2g\n', k, algo.s, algo.y0, algo.W, algo.b0, df, r2);
        end
    end
        
end

if ~isempty(W)
    algo.W=W;
    algo.b0=B;
    algo.s=S;
    algo.y0=Y;
end
    
if debug_me
    plot(algo, retDat, h);
    fprintf('Iter=%d, s=%5.2f, y0=%5.2f, w=%5.2f, b=%5.2f, my_r2=%5.2g\n', k, algo.s, algo.y0, algo.W, algo.b0, r2_min);
end

retDat=test(algo,retDat);
