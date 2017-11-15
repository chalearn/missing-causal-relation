function d =  testing(a,d)

 numex_training=get_dim(a.dtraining);
 numex_testing=get_dim(d);
 
 K=a.Kc;
 KK=get_kernel(a.child,a.dtraining);
 Kt=get_kernel(a.child,a.dtraining,d);
%  Kt=reshape(Kt,get_dim(d),get_dim(a.dtraining));
 
Ktc= (Kt-1/numex_training* ones(numex_testing,1)*ones(1,numex_training)*KK)*(eye(numex_training)-1/numex_training*ones(numex_training,numex_training));

% repmat(mean(a.dtraining.Y),numex_training,1)
Yest=Ktc*a.U*inv(a.T'*K*a.U+1e-5*eye(a.nroflatent))*a.T'* (a.dtraining.Y-repmat(mean(a.dtraining.Y),numex_training,1));
Yest=Yest+repmat(mean(a.dtraining.Y),numex_testing,1);
 d=set_x(d,Yest); 
 d=set_name(d,[get_name(d) ' -> ' get_name(a)]); 
  
