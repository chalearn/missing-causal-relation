function dat =  ker_test(algo,dat)
%dat =  ker_test(algo,dat)
% Make predictions with the kernel method.
% Inputs:
% algo -- A linear discriminant model.
% dat -- A data structure.
% Returns:
% dat -- The same data structure, but X is replaced by the discriminant
% values.

% Isabelle Guyon -- September 2005 -- isabelle@clopinet.com
% (written after the svm test routine of the spider)
% Modified Oct. 7 after Amir's idea to monitor the speed.
  
[p,n]=get_dim(dat);
if isempty(algo.alpha)
    yEst = algo.b0 * ones(p,1);
    dat=set_x(dat,yEst); 
    return
end

  %% <<---To avoid large kernel matrices, we test in batches---> 
sz=get_dim(algo.Xsv);  
if sz==0 sz=1; end;
p=get_dim(dat);
%batch_size=round((500^2)/sz);  %% <---500x500 point are the maximum for one batch
%batch_size=round(max(p/10, algo.algorithm.maxsize/sz));
batch_size=round(algo.algorithm.maxsize/sz);
   
yEst=[];
if p > batch_size
    if algo.algorithm.verbosity>0
        disp(['running ker_test...'])
    end
    tic;
    for i=1:batch_size:p
        ip=min(i+batch_size-1,get_dim(dat));
        take= i:ip;
        kerMaTemp=get_kernel(algo.child,get(dat,take),algo.Xsv);
        yEst=[yEst; ((algo.alpha'* kerMaTemp)+algo.b0)'];
        if algo.algorithm.verbosity>0
            fprintf('%d%%(%5.2f sec) ', round(100*ip/p), toc);
        end
    end
    if algo.algorithm.verbosity>0
        disp(['... done'])
    end
else
    kerMa=get_kernel(algo.child, dat, algo.Xsv);
    yEst=((algo.alpha'* kerMa)+algo.b0)';
end
  
% remove ties:
zero_val=find(yEst==0);
yEst(zero_val)=algo.algorithm.default_output*eps;

dat=set_x(dat,yEst);


