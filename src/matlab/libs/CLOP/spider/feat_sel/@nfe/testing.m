function d =  testing(a,d)
 
 feat=a.feat; if isempty(feat) feat=length(a.rank);   end;
 rank=a.rank(1:feat);             % features to select
  
 d=get(d,[],rank);  % perform the feature selection
 d=set_name(d,[get_name(d) ' -> ' get_name(a)]);
 
 if a.output_rank==0  %% output selected features, not label estimates
   d=test(a.child,d);  % train underlying algorithm 
 end
 