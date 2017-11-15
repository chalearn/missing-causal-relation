
function a = exp_ker(hyper) 
%=============================================================================
% EXP_KER Exponential kernel object             
%=============================================================================  
% a=exp_ker
% Build an exponential kernel of size dim1 x dim2
% By default, the decay parameter is 0.2*dim in either direction.
%
%   Hyperparameters:
%   dim1, dim2           -- kernel dimensions (rows, columns)
%   sigma1, sigma2       -- decay parameters
%
%   Data member:
%   X                    -- kernel
%
% Methods:
%  get_name, get_dim, get_x 
%
%=============================================================================
% Author of code: Isabelle Guyon -- isabelle@clopinet.com -- November 2005
%=============================================================================

% <<------hyperparam initialisation------------->> 
a.display_fields={'dim1', 'dim2', 'sigma1', 'sigma2'};
a.dim1= default(9, [0,Inf]); % Don't try Inf :=)
a.dim2= default(9, [0,Inf]); % Prefer odd numbers
a.sigma1= default([], [0,Inf]);
a.sigma2= default([], [0,Inf]);

% <<-------------data----------------->> 

algoType=data('exp_ker');
a= class(a,'exp_ker',algoType);

eval_hyper;

% Build the kernel:
if isempty(a.sigma1)
    a.sigma1=0.2*a.dim1;
end
if isempty(a.sigma2)
    a.sigma2=0.2*a.dim1;
end

v1=zeros(a.dim1,1);
for i=1:a.dim1
    v1(i)=exp(-abs(((i-1)-(a.dim1-1)/2))/a.sigma1);
end
v2=zeros(1,a.dim2);
for i=1:a.dim2
    v2(i)=exp(-abs(((i-1)-(a.dim2-1)/2))/a.sigma2);
end
a.data.X=v1*v2;










