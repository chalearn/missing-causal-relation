
disp(['This demo shows model selection on the Yeast (5 classes) dataset.']); 
disp(['The models are: one_vs_rest, one_vs_one, c45, knn']); 
disp('[press a key]') 
pause 
 
clear classes; 
s=spider_path; 

% to implement with global data instead (less memory overhead):
%global X; global Y; 
%load([s 'demos/data/yeastXYmc5norm']); 
%d=data_global('Multi-class Yeast 5',[],[]); 

 load([s 'demos/data/yeastXYmc5norm']); %% without data_global
 d=data('Multi-class Yeast 5',X,Y); 

a1=group({one_vs_rest,one_vs_one,c45,knn});
a2=gridsel(a1,'folds=3');

[r,a]=train( cv({a1 a2},'folds=3;store_all') ,d  );

get_mean(r)
