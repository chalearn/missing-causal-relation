
function d =  generate(a)

  
 if ~isa(a.child,'cell') r=[]; r{1}=a.child; a.child=r; end;
 
 n=length(a.child); %% number of features to generate
 
 for j=1:length(n)  
   a.child{j}.l=a.l;
 end

 
 xs=[]; 
 for i=1:n
   x=get_x(test(a.child{j})); %% generate data with that class
   xs=[xs x];  
 end

 d=data(get_name(a),xs,[]); 
  
 
