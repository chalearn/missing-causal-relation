function [retDat,algo] =  training(algo,retDat)

if algo.algorithm.verbosity>0
    disp(['training ' get_name(algo) '.... '])
end


nrofsamples=get_dim(retDat);
W=calc(algo.propkern,retDat);
% W=W+eye(nrofsamples);
% W=1./W;
algo.W=W-diag(diag(W));
algo.D=diag(sum(W));
D=algo.D;
algo.S=D^(-0.5)*W*D^(-0.5);
S=algo.S;
Y=inv(eye(nrofsamples)-algo.wide*S)*retDat.Y;
Yestimated=sign(S*Y);

retDat=data(get_x(retDat),Yestimated);

opt=algo.optimizer;
if strcmp(algo.optimizer,'default')
    len=length(retDat.Y);
    if len<=200  %% <---if there are more then 200 eamples use svm_light
        opt='andre';
    else
        opt='svmlight';
    end
end
if algo.nu~=0,
    opt='libsvm';
end;


switch opt
    %%<<----------------Andre optimizer-------------------->>
    case {'andre'}   
        
        [KerMa,algo.child]=train(algo.child,retDat); 
        KerMa=KerMa.X;    %% calc kernel
        KerMa=add_ridge(KerMa,algo,retDat); 
        y=get_y(retDat); 
        KerMa=KerMa.*(y*y');
        if( algo.nob == 0)
            [alpha,bias] = quadsolve(KerMa,-ones(size(KerMa,1),1),y',0,algo.C); 
            bias0 = -bias;
        else
            alpha = quadsolve(KerMa,-ones(size(KerMa,1),1),[],0,algo.C); 
        end
        
        alpha= alpha .* y;
        %%<<----------------quadprog optimizer-------------------->> 
    case {'quadprog'} 
        
        [KerMa,algo.child]=train(algo.child,retDat); 
        KerMa=KerMa.X;    %% <--- calculate the kernel
        KerMa=add_ridge(KerMa,algo,retDat);  
        len=size(KerMa,1);  
        y=get_y(retDat); 
        KerMa=KerMa.*(y*y');
        opts= optimset('display','off','MaxIter',10000,'LargeScale','off'); 
        [alpha,fVAl,exit,out,lambda] = quadprog(KerMa,-ones(len,1),[],[],y',0, zeros(len,1),algo.C*ones(len,1),[],opts);
        bias0=lambda.eqlin(1);  
        alpha= alpha .* y;
    case {'quadprog_nob'} 
        
        [KerMa,algo.child]=train(algo.child,retDat); 
        KerMa=KerMa.X;    %% <--- calculate the kernel
        KerMa=add_ridge(KerMa,algo,retDat);  
        len=size(KerMa,1);  
        y=get_y(retDat); 
        KerMa=KerMa.*(y*y');
        opts= optimset('display','off','MaxIter',10000,'LargeScale','off'); 
        [alpha,fVAl,exit,out] = quadprog(KerMa,-ones(len,1),[],[],[],[], zeros(len,1),algo.C*ones(len,1),[],opts);
        bias0=0;  
        alpha= alpha .* y;
        %%<<----------------svmlight optimizer-------------------->>  
    case {'svmlight'} 
        
        algo.child.dat=retDat; %% <<-- kernel has to store data now
        [x y]=get_xy(retDat);
        if strcmp(algo.child.ker,'linear') 
            ker=1; 
            param1=1; 
        end;
        if strcmp(algo.child.ker,'poly') 
            ker=2; 
            param1=algo.child.kerparam; 
        end;
        if strcmp(algo.child.ker,'rbf') 
            ker=3; 
            param1=algo.child.kerparam; 
            param1=(2*param1^2);   
        end;
        if strcmp(algo.child.ker,'weighted_linear') 
            ker=1; 
            param1=1; 
            tmp = algo.child.kerparam; 
            x=x .* repmat(tmp,size(x,1),1); %%<--- weight data according to parameters
        end;
        if strcmp(algo.child.ker,'custom_fast') | strcmp(algo.child.ker,'custom') | strcmp(algo.child.ker,'from_data')
            x=get_kernel(algo.child,retDat,retDat);  %%<--- calculate kernel
            x = [[1:size(x,1)]' x]; 
            ker=4; 
            param1=1;
        end;
        x=full(x);
        [alphas bias0 ind] = svmlight(x,y,algo.C,algo.ridge,algo.balanced_ridge,ker,param1, ...
            max(0,algo.algorithm.verbosity-1));
        if algo.algorithm.verbosity>1 
            disp('done!'); 
        end;
        alpha=zeros(size(x,1),1); 
        alpha(ind+1)=alphas;
        
        %%<<----------------libsvm optimizer-------------------->>
    case {'libsvm'} 
        
        %      
        x=[];
        y=[];
        svm_type=0;
        kernelType=0;
        degree=3;
        gamma=0;
        coef0=0;
        
        nu=algo.nu;
        if(nu>0)
             svm_type=1;
        end

        
        cachesize=40;
        C=algo.C;
        eps=1e-3;
        p=0.1;
        shrinking=1;
        
        weight_label=[];
        weight=[];
        nr_weight=0;
        
        if strcmp(algo.child.ker,'linear')
            kernelType = 0;
        end;
        if strcmp(algo.child.ker,'poly')
            kernelType = 1; 
            degree = algo.child.kerparam;
            coef0 = 1;
            gamma = 1;
        end;
        if strcmp(algo.child.ker,'rbf'),
            kernelType = 2; 
            sigma = algo.child.kerparam; 
            gamma = 1/(2*sigma^2);
        end;
        if algo.balanced_ridge~=0,
            ['balanced ridge is ignored for libsvm ...']
        end;
        
        y=get_y(retDat); 
        x=get_x(retDat);


        [alpha,xSV,bias0]=libsvm_classifier_spider(x,y,svm_type,kernelType,...
            degree,gamma,coef0,nu,cachesize,C,eps,p,weight_label,weight,nr_weight);
    
        %~ fprintf('\nSorting..\n');
        %~ alphatmp = zeros(size(x,1),1);
        %~ for i=1:length(alpha)
            %~ I=repmat( xSV(i,:),size(x,1),1) == x;
            %~ A=find(I~=0);
            %~ res=ind2sub(size(x),A(1));
            %~ alphatmp(res)=alpha(i);
        %~ end
        %~ fprintf('Done\n');
        
        %~ % the sign depends on the order of labels
        %~ alpha = alphatmp * y(1); 
        %~ bias0 = bias0 * y(1)
        %~ algo.C = CC;
        
        % case {'libsvm'} 
        %     
        %         'using old libsvm'    
        %     algo.child.dat=retDat; %% <--- kernel has to store data now
        %     if algo.nu==0,
        %         svm_type = 0; C = min([algo.C,10000]); 
        %         nu=0;
        %     else
        %         svm_type = 1; 
        %         nu = algo.nu; 
        %         algo.C = -1; 
        %         C=1;
        %     end;
        %     degree = 0; 
        %     coef0 = 0;
        %     
        %     %% <<-------------libsvm parameters (defaults)----->>
        %     cache_size = 40; 
        %     eps = 0.001; 
        %     shrinking=1;
        %     nrWeight = 0; 
        %     weightLabel =0; 
        %     weight = 1;
        %     epsilon = 1; 
        %     gamma=1;
        %     
        %     if strcmp(algo.child.ker,'linear')
        %         kernelType = 0;
        %     end;
        %     if strcmp(algo.child.ker,'poly')
        %         kernelType = 1; 
        %         degree = algo.child.kerparam; 
        %         coef0 = 1;
        %     end;
        %     if strcmp(algo.child.ker,'rbf'),
        %         kernelType = 2; 
        %         sigma = algo.child.kerparam; 
        %         gamma = 1/(2*sigma^2);
        %     end;
        %     if algo.balanced_ridge~=0,
        %         disp('Warning: balanced ridge only for C-SVC (libsvm).');
        %         C1 = (algo.balanced_ridge)*length(y)/length(find(y==1));
        %         Cn1 = (1-algo.balanced_ridge)*length(y)/length(find(y==-1));
        %     end;
        %     y=get_y(retDat); 
        %     x=get_x(retDat);
        %     [alpha,bias0,xSV,eps,CC] = svmlibtrain(x,y,svm_type,kernelType,degree,gamma,coef0,nu,cache_size,C,eps,...
        %         epsilon,shrinking,nrWeight,weightLabel,weight,0);    
        %     bias0=-bias0;%% libsvm
        %     %    Reorder the alphas, so we have the same X-Support-Vectors for all runs.
        %     %    Needed for one_vs_rest
        %     alphatmp = zeros(size(xSV,1),1);
        %     indTemp = find(xSV(:,size(xSV,2))~=0);
        %     indTemp2 = xSV(indTemp,size(xSV,2));
        %     alphatmp(indTemp2) = alpha(indTemp)*y(1);
        %     alpha = alphatmp;   
        %     % problems with libsvm => scale alpha and b by y(1)
        %     bias0 = bias0*y(1);    
        %     algo.C = CC; 
        % end
        
        alpha = alpha * y(1);         
        bias0 = bias0 * y(1); 
        
        algo.b0=bias0;
%         fin=find(abs(alpha)>algo.alpha_cutoff);
        algo.alpha=alpha;
        algo.Xsv=data(xSV);
        
        if algo.algorithm.do_not_evaluate_training_error
            retDat=set_x(retDat,get_y(retDat)); 
        else
            retDat=test(algo,retDat);
        end
        
        return
  
%          fprintf('\nSorting..\n');
%          alphatmp = zeros(size(x,1),1);
%          for i=1:length(alpha)
%            I=repmat( xSV(i,:),size(x,1),1)- x;
%            A=find(I==0);
%            res=ind2sub(size(x),A(1));
%            alphatmp(res)=alpha(i);
%        end
%          fprintf('Done\n');
% 
        % the sign depends on the order of labels
         alpha = alphatmp * y(1); 
         bias0 = bias0 * y(1); 
           
% case {'libsvm'} 
%     
%         'using old libsvm'    
%     algo.child.dat=retDat; %% <--- kernel has to store data now
%     if algo.nu==0,
%         svm_type = 0; C = min([algo.C,10000]); 
%         nu=0;
%     else
%         svm_type = 1; 
%         nu = algo.nu; 
%         algo.C = -1; 
%         C=1;
%     end;
%     degree = 0; 
%     coef0 = 0;
%     
%     %% <<-------------libsvm parameters (defaults)----->>
%     cache_size = 40; 
%     eps = 0.001; 
%     shrinking=1;
%     nrWeight = 0; 
%     weightLabel =0; 
%     weight = 1;
%     epsilon = 1; 
%     gamma=1;
%     
%     if strcmp(algo.child.ker,'linear')
%         kernelType = 0;
%     end;
%     if strcmp(algo.child.ker,'poly')
%         kernelType = 1; 
%         degree = algo.child.kerparam; 
%         coef0 = 1;
%     end;
%     if strcmp(algo.child.ker,'rbf'),
%         kernelType = 2; 
%         sigma = algo.child.kerparam; 
%         gamma = 1/(2*sigma^2);
%     end;
%     if algo.balanced_ridge~=0,
%         disp('Warning: balanced ridge only for C-SVC (libsvm).');
%         C1 = (algo.balanced_ridge)*length(y)/length(find(y==1));
%         Cn1 = (1-algo.balanced_ridge)*length(y)/length(find(y==-1));
%     end;
%     y=get_y(retDat); 
%     x=get_x(retDat);
%     [alpha,bias0,xSV,eps,CC] = svmlibtrain(x,y,svm_type,kernelType,degree,gamma,coef0,nu,cache_size,C,eps,...
%         epsilon,shrinking,nrWeight,weightLabel,weight,0);    
%     bias0=-bias0;%% libsvm
%     %    Reorder the alphas, so we have the same X-Support-Vectors for all runs.
%     %    Needed for one_vs_rest
%     alphatmp = zeros(size(xSV,1),1);
%     indTemp = find(xSV(:,size(xSV,2))~=0);
%     indTemp2 = xSV(indTemp,size(xSV,2));
%     alphatmp(indTemp2) = alpha(indTemp)*y(1);
%     alpha = alphatmp;   
%     % problems with libsvm => scale alpha and b by y(1)
%     bias0 = bias0*y(1);    
%     algo.C = CC; 
% end

%~ >>>>>>> 1.3
end

algo.b0=bias0;
fin=find(abs(alpha)>algo.alpha_cutoff);
algo.alpha=alpha(fin);
algo.Xsv=get(retDat,fin);

if algo.algorithm.do_not_evaluate_training_error
    retDat=set_x(retDat,get_y(retDat)); 
else
    retDat=test(algo,retDat);
end


