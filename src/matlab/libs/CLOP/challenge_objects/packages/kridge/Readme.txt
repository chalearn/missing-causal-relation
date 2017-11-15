Kernel Ridge Regression via Gauss-Seidel v0.1  08.07.2006

This is a c++ implementation of the gauss seidel method for the solution of the problem

	\min_\alpha  \alpha^\top K \alpha -Y^\top \alpha
	
The current version uses a row cached of the kernel matrix and a maximum
residual selection strategy for row selection plus some probabilistic strategy change.  It is known that if K is not full rank
(i.e. mostly) this will lead to oscillation of in the space of alpha and to a 
stagnation of the objective function.  

Usage: [alpha,flag]=rrtrain(ARGS) 
where Args is a list of _CELL_ array of type :  {'id', variable}
possible id's are: 
Mandatory: {'X', matrix}  : The data matrix X. 
Mandatory: {'Y', vector}  : The target vector Y. 
Mandatory: {'kerneltype', 0 OR 1 OR 2}  : The used kernel: 0-linear, 1-poly, 2-rbf. 
Mandatory: {'ridge', scalar>0}  : The used ridge value. 
Optional:  {'eps', scalar>0}  : The used accuracy for comparing changes in the objective function. 
Optional:  {'cachesize', scalar>1}  : The used number of MB for caching. 
Optional:  {'degree', scalar>1}  : The used degree for the poly kernel: (x'*y +c)^!d!. 
Optional:  {'coef0', scalar>0}  : The used coefficient for the poly kernel: (x'*y +!c!)^d. 
Optional:  {'gamma', scalar>0}  : The used coefficient for the rbf kernel: exp(-gamma*||x-y||^2). 
Optional:  {'verbosity', 0 or 1}  : Switches on/off messages while optimization. 
Optional:  {'safety', 0 or 1}  : This switch forces to store intermediate solution vector to the 
                                   variable [rrtrain_alpha] in Matlabs *global* workspace 
Optional:  'alpha', vector}  : If this vector provided then the solver performs a hot start.  
		return;


Note:

If you can calculate K explicitly use direct matrix inversion or a CG method.
The gauss seidel solution is quite slow but scales well. 
Furthermore, you might want to consider solutions for prediction 
obtained by smaller accuracy. This could be a significant speedup when done for example 
during cross-validation experiments.

Example: 
% ------sinc problem-------
clear all;
N=3000;  % matlabs limit regarding matrix size on my teeny weeny laptop
X=linspace(-10,10,N)'; 
w=randn(size(X,2),1);
y=sin(X)./X+1e-1*randn(N,1);

rr=1;

safety=0;

sigma=1;

gamma=1/(2*sigma^2);

% computation start
disp('Starting to optimize')
tic,
[alpha,fval]=rrtrain({'X',X},{'Y',y},{'ridge',rr},{'kerneltype',2},{'gamma',gamma},{'eps',1e-3},{'cachesize',50},...
{'safety',safety},{'verbosity',1});
time1=toc

disp('finished')


disp('plotting...')
K=calc(kernel('rbf',sigma),data(X));
yest= K*alpha;
clf,plot(X,y,'.',X,yest,'r.')

norm(y-yest)


Alternative Example: 
%all as above but now 
safety=1;

% interrupt this while running.. 
% set eps=1e-12
eps=1e-12;
% computation start
disp('Starting to optimize')
tic,
[alpha,fval]=rrtrain({'X',X},{'Y',y},{'ridge',rr},{'kerneltype',2},{'gamma',gamma},{'eps',eps},{'cachesize',50},...
{'safety',safety},{'verbosity',1});
time1=toc
disp('finished')

% After interrupt

whos global
 
% you should see now 
%rrtrain_alpha               3000x1                     24000  double array (global)
%
% We can use this intermediate solution for inspection purposes
global rrtrain_alpha;
yest2= K*rrtrain_alpha;
plot(X,y,'.',X,yest2,'r.')

Compilation:

mex -I. kernel.cpp matrixcache.cpp mexarg.cpp rr-train.cpp mexmain.cpp mmm.c -output rrtrain



You are invited to reverse-engineer!



Gökhan BakIr 
