function [retRes,retAlgo] = training(retAlgo,dat)
  
  if retAlgo.algorithm.verbosity
    disp(['training ' get_name(retAlgo) '.... '])
  end
  
X=get_x(dat);
Y=get_y(dat);
resu=zeros(size(Y));

n=length(Y);
for k=1:n
    tr=[1:k-1,k+1:n];
    te=k;
    Dtr=data(X(tr,:),Y(tr));
    Dte=data(X(te,:),Y(te));
    [d, m]=train(retAlgo.child, Dtr);
    dd=test(m, Dte);
    resu(k)=dd.X;
end

retRes=data(resu, Y);