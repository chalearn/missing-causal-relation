function [res,a] =  training(a,d,loss_type)
       
  disp(['training ' get_name(a) '.... '])
  
  %% ---- decomposition --------------------
  
%   [L,a.ok]=train(a.ok,d); L=L.X;   % calc output kernel

  if a.use_pca  %% don't understand why, but this doesn't seem to work !!!!!???!
      kpt = kpca;
      kpt.child = a.ok;
      kpt.child.calc_on_output = 0;
      [uv kp]=train(kpt,data(d.Y));%% do kernel pca on outputs 
      a.kpca = kp;                                  
    if ~isempty(a.feat)
        if a.feat == 0
            uv = uv.X;
            a.kpca.feat = size(uv,2);
        else
            uv=uv.X(:,1:a.feat); 
            a.kpca.feat = a.feat;
        end    
    else
      disp(['    Taking all direction which have lambda > lambda_max*' num2str(a.lambda_frac)]);
      uv=uv.X(:,1:sum(kp.e_val>max(kp.e_val)*a.lambda_frac)); % take top max_eig*a.lambda_frac
      a.feat = size(uv,2);
      a.kpca.feat = a.feat;
    end
  end

%   if a.use_pca       %% do KPCA internally, don't call kpca object
%     I=eye(length(L));  
%     O=ones(length(L))/length(L);
%     L=(I-O)*L*(I-O);               % centering
%     if ~isempty(a.feat)            % decomposition
%       opts.disp=0;[u,v]=eigs(L,a.feat,'LM',opts);
%     else
%       [u,v]=eig(L);      
%     end
%     uv=(u*sqrt(abs(v)));   % projection 
%     [vals ind]=sort(-diag(abs(v)));
%     uv=uv(:,ind);          % first direction now the most important 
%     rows=a.feat;
%     if isempty(a.feat)           % choose cutoff as lambda>lambda_max/10000
%       v1=diag(v); rows=sum(v1>max(v1)/10000);
%     end 
%     uv=uv( :, 1:rows);     % only take first few rows (principal directions) 
%     
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %% new section to treat degenerate subspaces %
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     vals = Ftrunc( vals( 1:rows), 8);   % round to 8 significant digits
%     if length( unique( vals)) < rows    % is there a degenerated subspace ??
%       for vv = unique( vals)
%         subind = ( vals == vv);
%         if sum( subind) > 1             % do orthonormalization of the degenerate subspace
%           subsp = uv( :, subind);
%           uv( :, subind) = orth( subsp) * sqrt( abs( vv));
%         end
%       end
%     end
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     
%   end 
%   

  if ~a.use_pca   %% quick & dirty non-kpca method... center and use
    I=eye(length(L));  
    O=ones(length(L))/length(L);
    L=(I-O)*L*(I-O);               % centering
    uv=L; 
  end
  

  %% ----- learning the map -----------------
    %a2=lms(a.child); a2.use_b=0; a2.ridge=a.ridge; a2=multi_reg(a2); 
    %d2=data(d.X,uv); d2.index=d.index;
    %[tr,a2]=train(a2,d2); a.alpha=a2; a.Xsv=d; a.uv=d2;
    
  if a.do_input_kpca
    disp(['  Performing input kpca with ' get_name(a.ik)]);    
    a.kpca_in.child = a.ik;
    [resu algo] = train(a.kpca_in,data(get_x(d)));
    X = resu.X;
    a.kpca_in = algo;
  end
    
  a2=multi_rr;  a2.child=a.child;
  a2.use_b=0;  a2.ridge=a.ridge; 
  d2=data(d.X,uv); d2.index=d.index;
  [tr,a3]=train(a2,d2);
  a.alpha=a3; a.Xsv=d; a.uv=d2;  %% store results

  if a.algorithm.do_not_evaluate_training_error==1
    res=d; res.X=res.Y;
  else
    res=testing(a,d);
  end
  