
disp(['This demo compares l0 with FSV on the Colon dataset.']);
disp('[press a key]')
pause

clear classes;
s=spider_path;
load([s 'demos/data/colon']);
for i=1:size(X,1),
X(i,:)=X(i,:)/norm(X(i,:));
end;
d=data('colon',X,Y);
clear X Y T;
a1 = feat_sel(9,l0,svm);
b = feat_sel(9,fsv,svm);

%a1 = l0;
%a1.output_rank=0;
%a2 = fsv;
a=group({a1,b});
a=cv(a,'folds=2');
[r a]=train(a,d);
get_mean(r)




