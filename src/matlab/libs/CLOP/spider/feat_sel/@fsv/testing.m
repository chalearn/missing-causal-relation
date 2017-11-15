function d =  testing(a,d)

 d=set_name(d,[get_name(d) ' -> ' get_name(a)]);
 
 if a.output_rank==1  %% output features with best correlation scores
   feat=a.feat; if isempty(feat) feat=length(a.rank);   end;
   d=get(d,[],a.rank(1:feat));     %% perform feature selection
 else
   Yest=(a.w*get_x(d)'+a.b0)';      
  if a.algorithm.use_signed_output==1
       Yest=sign(Yest);
  end   
  d=set_x(d,Yest);
end;


 
