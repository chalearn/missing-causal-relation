
disp(['This demo compares several svr optimization codes using a hard margin.']);
disp('The optimizers are: libsvm and andre')
disp('The problem is to learn (a regression) on a non noisy function');
disp('Two algorithms are tested with both optimizers: C-SVR and nu-SVR');
disp('[press a key]')
pause
clear classes
s=spider_path;
%%% Build toy data
m=50;
X = rand(m,1);
Y = sin(10*(X-0.5))./(0.5+X.^2);
%% Sort the data to print on a figure
[u,v] = sort(X);
plot(X(v),Y(v),'b');
%% Build the dataset
ds=data('toy reg data',X,Y);
%% Built the kernel
k=kernel('rbf',0.1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% NU-SVR
%% Build the algorithms
a1=svr({k,'optimizer="libsvm"','nu=0.5','C=1'}); 
a2=svr({k,'optimizer="andre"','nu=0.5','C=1'});
a=group({a1 a2});
 
'calculating epsilons and b0s of different optimizers'
%% Train and Test
[tr a]=train(a,get(ds,[1:25]));
[r]=test(a,get(ds,[26:50]));  

%% Print the value given by the optimizers
  b0s=[a{1}.b0  a{2}.b0 ]
  epsilons = [a{1}.epsilon,a{2}.epsilon]  
 [a{1}.alpha a{2}.alpha]
  
  'press key to calculate real outputs for different optimizers'
  pause
  %% Build new algorithms 
  a1=svr({k,'optimizer="libsvm"','nu=0.5','C=1'});
  a2=svr({k,'optimizer="andre"','nu=0.5','C=1'});  
 
  ass=group({a1 a2});
  a=ass;
  
  %% Train and Test
  [tr a]=train(a,get(ds,[1:25]));
  [d ]=test(a,get(ds,[26:50]));  
  
 %% Get the real outputs
  [get_x(d{1}) get_x(d{2})]
  
  %% Print on the figure
  hold;
   
  [u,v] = sort(X([26:50]));
  tmp = get_x(d{1});
  Xtmp = X([26:50]);
  Xtmp = Xtmp(v);
  plot(Xtmp,tmp(v),'-xg');
  tmp = get_x(d{2});
  plot(Xtmp,tmp(v),'-dr');
  
  hold;  
  title('nu-SVR');
  legend('original curve',['libsvm, e=' num2str(a{1}.epsilon)] ,['andre,e=' num2str(a{2}.epsilon)]);
  
  %%%%%%%%%%%%%%%%%% ESPILON - SVR
  
    figure(2);
    title('epsilon-SVR, epsilon=0.05');
    %% Build the algorithms
    a1=svr({k,'optimizer="libsvm"','C=1'}); 
    a2=svr({k,'optimizer="andre"','C=1'});
    a=group({a1 a2});
 
disp('Calculating the b0 and the alpha');
%% Train and Test
  [tr a]=train(a,get(ds,[1:25]));
  [r ]=test(a,get(ds,[26:50]));

%% Print the value given by the optimizers
  b0s=[a{1}.b0  a{2}.b0 ]
 [a{1}.alpha a{2}.alpha]
  
  'press key to calculate real outputs for different optimizers'
  pause
  %% Build new algorithms 
  a1=svr({k,'optimizer="libsvm"','C=1'});
  a2=svr({k,'optimizer="andre"','C=1'});  
 
  ass=group({a1 a2});
  a=ass;
  
  %% Train and Test
  [tr a]=train(a,get(ds,[1:25]));
  [d ]=test(a,get(ds,[26:50]));
  

  
  %% Get the real outputs
  [get_x(d{1}) get_x(d{2})]
 
  %% Print on the figure
  hold;
   [u,v] = sort(X);
   plot(X(v),Y(v),'b');
  [u,v] = sort(X([26:50]));
  tmp = get_x(d{1});
  Xtmp = X([26:50]);
  Xtmp = Xtmp(v);
  plot(Xtmp,tmp(v),'-xg');
  tmp = get_x(d{2});
  plot(Xtmp,tmp(v),'-dr');
  legend('original curve','libsvm','andre');   
  hold;  
  
 
