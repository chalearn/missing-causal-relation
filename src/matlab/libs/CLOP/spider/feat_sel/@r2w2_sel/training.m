function [res,a] =  training(a,d)
    
if a.algorithm.use_prev_train==1&a.algorithm.trained==1,     %% do nothingelse
% set grad descent options
options = optimset('GradObj','on');
options = optimset(options,'LargeScale','off');
options = optimset(options,'DerivativeCheck','off');
options = optimset(options,'Display','iter');
options = optimset(options,'MaxIter',a.max_iter);
options = optimset(options,'TolFun',1e-4);
options = optimset(options,'TolX',1e-4);
options = optimset(options,'LineSearchType','cubicpoly');
if a.steep_ascent 
  options = optimset(options,'HessUpdate','steepdesc');     
end
% learn scaling factors and slacking (!) factors __________
[l n k]=get_dim(d); % n features to optimize over
if a.scales==1 a.scales=[1:n]; end;   sc=max(a.scales); 
sl=max(a.slacks); %% slack vars to optimize
a.sigma = [ones(sc,1); 1e-1*ones(sl,1)];
p1=1; if length(a.kerparam)==2 p1=a.kerparam{2}; end;
a.sigma = fminunc('svr2w2',a.sigma,options,d.X,d.Y,a.ker,p1,a.scales,a.slacks,a.optimizer,a.use_var2);

a.child=svm(kernel(a.ker,a.kerparam));  % initialize svm 

if sl>0   a.child.ridge=(a.sigma(sc+1:sc+sl)).^2; end;      % remember slacks

if sc>0 % if we chose scaling factors
[s rank]=sort(-abs(a.sigma(a.scales))); a.rank=rank'; % remember scales  
if a.output_rank==0 % train underlying svm on given features
  
  if isempty(a.feat)                       %% feature scaling
    a.child.kerparam = {a.sigma(a.scales)',p1}; % so scale them features 
    [res,a.child]=train(a.child,d);
  else                               
    rank=a.rank(1:a.feat);              % else feature selection
    d2=get(d,[],rank);                  % perform the feature selection
    a.child.kerparam ={ones(a.feat,1)',p1}; % scale all features the same
    [res,a.child]=train(a.child,d2);
  end
end 
else
   a.child.kerparam = ones(1,n);
   [res,a.child]=train(a.child,d);
endend

res=test(a,d);

  
  
  


