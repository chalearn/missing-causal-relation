function d =  testing(a,d)
     
 if isempty(a.feat) %% feature scaling
   d=test(a.child,d);
 else
   rank=a.rank(1:a.feat);             % features to select
   d=get(d,[],rank);  % perform the feature selection   
   d=set_name(d,[get_name(d) ' -> ' get_name(a)]);
   if a.output_rank==0  %% output selected features, not label estimates
     d=test(a.child,d);  % train underlying algorithm 
   end 
 end 
     


