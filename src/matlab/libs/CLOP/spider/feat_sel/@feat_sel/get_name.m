function s=get_name(a)
s=[get_name(a.algorithm)];
s=[s '(' get_name(a.rank_alg) ',' get_name(a.clas_alg) ')'];

eval_name
 
index=num2str(a.feats); 

a=find(index==32); 
a=a(1:2:length(a)); 

a=setdiff([1:length(index)],a); 
index=index(a); 
s=[s ' feats=[' index ']']; 
