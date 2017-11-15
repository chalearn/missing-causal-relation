
function a = fourier(hyper) 
%=============================================================================
% FOURIER object for preprocessing by fourier transform           
%=============================================================================  
% a=convolve(hyperParam) 
%
% Performs a 2-d fft of each pattern of the data matrix
% that is first resized as a 2-d image.
% The preprocessed data is the spectrum modulus.
%
% No hyperparameter
%
% Methods:
%  train, test 
%=============================================================================
% Author of code: Isabelle Guyon -- isabelle@clopinet.com -- November 2005
%=============================================================================
a.name='fourier';
algoType=algorithm('fourier');
a= class(a,'fourier',algoType);

a.algorithm.verbosity=1;












