function a = spectral(hyper)
 
%=============================================================================================
% Spectral clustering   
%============================================================================================= 
% 
% A=SPECTRAL(H) returns a spectral clustering object
% initialized with hyperparameters H.
%
% Structure of a spectral object:
%
% Parameters:
%
%   child=distance  -- distance measure
%   sigma=[]        -- controls the scale of exponential
%                      if sigma is set to a number, no research is done.
%                      Otherwise, the distortion is minimized wrt. sigma
%
%   k=2             -- number of desired cluster
%   
% Model
%
%   d                -- training set containing the inputs as well as
%                       the clusters (in the Y field)
%
% Methods:
%   training: cluster a dataset
%   testing:  assign points to clusters according to the 
%             cluster of the nearest point
%
% Description:
%
%   The object is trained via an eigenvalue decomposition of a matrix derived from
%   its affinity matrix K:
%           K(i,j) = exp(-d(x_i,x_j)/(2sigma^2));
%
%   The lines of the k largest eigenvectors are normalized and are clustered with
%   k-means. The choice of sigma is optimized to minimize the distortion of this k-means
%   clustering.
% Example : 
%   d=gen(spiral({'m=300','n=0.5','noise=0.35'}));
%   plot(d.X(:,1),d.X(:,2),'r.'); 
%   d.Y=[];
%   ['Press Key']
%   pause;
%   [r,a]=train(spectral('sigma=0.05'),d); 
%   I=find(r.X==1);clf;hold on;
%   plot(d.X(I,1),d.X(I,2),'r.');
%   I=find(r.X~=1);
%   plot(d.X(I,1),d.X(I,2),'b.');
%=============================================================================================
% 1. Reference : On Spectral Clustering: Analysis and an algorithm
% Author       : Andrew Y. Ng, Michael I. Jordan, Yair Weiss
% 1. Link      : http://citeseer.ist.psu.edu/ng01spectral.html
% 2. Reference : Spectral kernel methods for clustering. In Neural Information Processing Systems
% Author       : Christianini, J. Shawe-Taylor, and J. Kandola.
% 2. Link      : http://citeseer.ist.psu.edu/context/2076443/0
%=============================================================================================

  a.child=distance;
  a.sigma=[]; 
  a.d=[];
  a.k=2;
  
  p = algorithm('spectral');
  a = class(a,'spectral',p);
  if nargin==1,
    eval_hyper;
  end;
