function d =  testing(a,d,loss_type)  

[r]=testing(a.alpha,d);  


if a.do_input_kpca
    disp(['  Performing input kpca with ' get_name(a.ik)]);    
    resu = test(a.kpca_in,data(get_x(d)));
    X = resu.X;
end


if a.output_preimage==2 %%output projections in feature space, no preimage
    Yest=r.X;
    tmp = test(a.kpca,data(get_y(d)))
    d.Y =tmp.X;
elseif a.output_preimage == 3
    disp(['    Find preimage from ' get_name(d)]);
    
    %the idea is that K = xt*x' = uv2*a.uv.Y'. So uv2 = K*pinv(a.uv.Y')
    %the rest is just like evaluation kde
%     [K] = get_kernel(a.ok,a.Xsv,d);
%     
%     %restore uncentered old kernel (checked)
%     [Kt] = get_kernel(a.ok,a.Xsv,a.Xsv);
%     
%     %center the new kernelmatrix according to old mean
%     [n,m] = size(K);
%     Om = ones(m)/m;
%     On = ones(n,m)/m;
%     I = eye(m);
%     
%     %brackets are for better numerical condition 
%     K = (K - On*Kt)*(I-Om);
    
    uv2 = test(a.kpca,data(get_y(d)));  
    uv2 = uv2.X;
    %computing the projection of the new preimages
%     uv2 = K*pinv(a.uv.Y',0);
    
    
    D=uv2 * r.X';   
    Dn=sum(uv2 .^ 2,2);  
    Dn2=sum(r.X .^ 2,2);    
    D = ones(length(Dn),1)*Dn2' + Dn*ones(1,length(Dn2)) - 2*D;  
    [v is]=min(D); % is indexes preimages we think are best  
    
    Yest = is;
    %Yest=d.Y(is,:); %% assign labels   
elseif a.output_preimage == 5
    disp(['    Find preimage from ' get_name(d)]);
    
    uv2 = test(a.kpca,data(get_y(d)));  
    uv2 = uv2.X;
    
    D=uv2 * r.X';   
    Dn=sum(uv2 .^ 2,2);  
    Dn2=sum(r.X .^ 2,2);    
    D = ones(length(Dn),1)*Dn2' + Dn*ones(1,length(Dn2)) - 2*D;  
    [v is]=min(D); % is indexes preimages we think are best  
    
    Yest = [];
    for i = 1:size(D,2)
        [so so_ind] = sort(D(:,i)');
        Yest = [Yest;so_ind];    
    end
    
    
    
elseif a.output_preimage == 4
    disp(['    Find preimage from ' get_name(d)]);
    
    uv2 = test(a.kpca,data(get_y(d)));  
    uv2 = uv2.X;
    
    D=uv2 * r.X';   
    Dn=sum(uv2 .^ 2,2);  
    Dn2=sum(r.X .^ 2,2);    
    D = ones(length(Dn),1)*Dn2' + Dn*ones(1,length(Dn2)) - 2*D;  
    Yest = D';
    for i = 1:size(D,2)
        [so so_ind] = sort(D(:,i)');
        Yest = [Yest;so_ind];    
    end

elseif a.output_preimage == 6
    disp('Computing preimages explicitly from (weighted) linear kernel...')
    disp('   Note: If you use any other kernel your results are very likely to be wrong!')
    mu = mean(a.Xsv.Y); %computing mean from training data
    kde_out = r.X;
    if (length(a.ok.kerparam) == 0) %if there are kerparams then it is a weighted linear kernel
        disp('      computing from linear kernel...')
        Yest = (pinv(a.kpca.e_vec(:,1:a.feat)'*(a.Xsv.Y-repmat(mu,size(a.Xsv.Y,1),1)))*kde_out')' + repmat(mu,size(kde_out,1),1);
        %        Yest = (inv(a.kpca.e_vec'*(a.Xsv.Y-repmat(mu,size(a.Xsv.Y,1),1)))*kde_out')' + repmat(mu,size(kde_out,1),1);
    else % otherwise it must be a linear kernel
        disp('      computing from weighted_linear kernel...')
        Yest = (pinv(a.kpca.e_vec(:,1:a.feat)'*(a.Xsv.Y-repmat(mu,size(a.Xsv.Y,1),1))*diag(a.ok.kerparam{1}.^2))*kde_out')' + repmat(mu,size(kde_out,1),1);
        %        Yest = (inv(a.kpca.e_vec'*(a.Xsv.Y-repmat(mu,size(a.Xsv.Y,1),1))*diag(a.ok.kerparam{1}.^2))*kde_out')' + repmat(mu,size(kde_out,1),1);
    end
else       
    disp('  finding pre-image (from training images)...');   
    
    D=a.uv.Y * r.X';   
    Dn=sum(a.uv.Y .^ 2,2);  
    Dn2=sum(r.X .^ 2,2);    
    D = ones(length(Dn),1)*Dn2' + Dn*ones(1,length(Dn2)) - 2*D;  
    [v is]=min(D); % is indexes preimages we think are best  
    
    tmp = a.Xsv; tmp = get_y(tmp);
    Yest=tmp(is,:); %% assign labels   
    
    if a.output_preimage==1 
        Yest=a.Xsv.index; 
        Yest=Yest(is)';  
    end   
    %% assign identity of pre-images  
    
end

d=set_x(d,Yest);   





d=set_name(d,[get_name(d) ' -> ' get_name(a)]);   
