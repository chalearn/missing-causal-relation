disp(['This demo compares spectral and k-means clustering on the 2-D ring problem']); 
disp('[press a key]') 
pause 

clear classes  
s=spider_path; 

figure(1);
%%% In this demo, the longest part of the code consists in building a dataset
%%% In future version of the spider, there will be objects that
%%% automatically generates examples. The interesting part is
%%% the 'train the spider' part.

rand('seed',2);randn('seed',2);

%%% Build a dataset (ring example)
m=20;
dim = 2;
noise =1;

Xtmp = rand(10000,dim);
tmp = sqrt(sum((Xtmp-0.5*ones(size(Xtmp))).^2,2));
indtmp = find(tmp>=0.3&tmp<=0.4);
X1 = Xtmp(indtmp(1:2*m),:);
indtmp2 = find(tmp<=0.1); 
X2 = Xtmp(indtmp2(1:m),:);

X = [X1;X2];


Y = [ones(2*m,1);2*ones(m,1)];

%%% Add some noise
if noise,
    X = X + 0.03*randn(size(X));
end;


subplot(311);

%% Plot the clustering
plot(X(1:2*m,1),X(1:2*m,2),'*r');
hold
plot(X(2*m+1:3*m,1),X(2*m+1:3*m,2),'*b');
title('Desired clustering');
hold;

%% train the spider
d=data('clust',X,Y);
a=kmeans;
b=spectral;
c=group({a b});
[res,c] = train(c,d);

%%% Plot the results
subplot(312);

Ykm = res{1}.X;
tmp1 = find(Ykm==1);
tmp2 = find(Ykm==2);
plot(X(tmp1,1),X(tmp1,2),'*b');
hold;
plot(X(tmp2,1),X(tmp2,2),'*r');
title('K-means');
hold;
subplot(313);

Ysp = res{2}.X;
tmp1 = find(Ysp==1);
tmp2 = find(Ysp==2);
plot(X(tmp1,1),X(tmp1,2),'*b');
hold;
plot(X(tmp2,1),X(tmp2,2),'*r');
title('Spectral Clustering');
hold;





