
disp(['This demo compares several svm optimization codes using a hard margin.']);
disp('The optimizers are: svmlight,quadprog,andre,leon and libsvm')
disp('[press a key]')
pause
clear classes
s=spider_path;
load([s 'demos/data/colon']);
Ytmp = -ones(size(X,1),2);
for i=1:size(X,1),  
    X(i,:) = X(i,:)/norm(X(i,:));
end;
ds=data('colon data',X,Y);
clear X Y T ;  
k= kernel('rbf',2);
a1=svm({k,'optimizer="svmlight"'}); 
a2=svm({k,'optimizer="quadprog"'});
a3=svm({k,'optimizer="andre"'});
a4=svm({k,'optimizer="default"'}); 
a5=svm({k,'optimizer="libsvm"'}); 
a=group({a1 a2 a3 a4 a5});
 
'calculating alphas of different optimizers'
  [tr a]=train(a,get(ds,[1:45]));
  [r ]=test(a,get(ds,[46:62]));
  
%  alphas=[a{1}.alpha a{2}.alpha a{3}.alpha a{4}.alpha a{5}.alpha ]
%  b0s=[a{1}.b0 a{2}.b0 a{3}.b0 a{4}.b0 a{5}.b0 ]
 
  
  'press key to calculate real outputs for different optimizers'
  pause
  a1=svm({k,'optimizer="svmlight"'});  a1.use_signed_output=0; 
  a2=svm({k,'optimizer="quadprog"'});a2.use_signed_output=0; 
  a3=svm({k,'optimizer="andre"'});  a3.use_signed_output=0; 
  a4=svm({k,'optimizer="default"'});   a4.use_signed_output=0; 
   a5=svm({k,'optimizer="libsvm"'});a5.use_signed_output=0; 
  ass=group({a1 a2 a3 a4 a5});
  a=ass;

  [tr a]=train(a,get(ds,[1:45]));
  [d ]=test(a,get(ds,[46:62]));
  
  [get_x(d{1}) get_x(d{2})  get_x(d{3})  get_x(d{4}) get_x(d{5})]
  

