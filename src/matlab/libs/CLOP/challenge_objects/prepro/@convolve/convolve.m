
function a = convolve(hyper) 
%=============================================================================
% CONVOLVE object for preprocessing by convolution           
%=============================================================================  
% a=convolve(hyperParam) 
%
% Performs a 2-d convolution of each pattern of the data matrix
% that is first resized as a 2-d image, using a given kernel.
% By default, the kernel is a Gaussian kernel.
%
%   Hyperparameter:
%   child              -- a data object (X acting as a kernel)
%
% Methods:
%  train, test 
%=============================================================================
% Author of code: Isabelle Guyon -- isabelle@clopinet.com -- November 2005
%=============================================================================

% <<------hyperparam initialisation------------->> 
if nargin<1, 
    a.child=gauss_ker;
else
    a.child=hyper;
end

algoType=algorithm('convolve');
a= class(a,'convolve',algoType);

a.algorithm.verbosity=1;












