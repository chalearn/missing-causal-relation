function results = testing(alg,dat)

feat = alg.feat;
if isempty(alg.feat) 
	feat=length(alg.rank);   
end;   
 results=get(dat,[],alg.rank(1:feat));     %% perform feature selection
 results=set_name(results,[get_name(results) ' -> ' get_name(alg)]);
 
 if alg.output_rank==0  %% output selected features, not label estimates
   results=test(alg.child,results);  % train underlying algorithm 
 end 
  
 
