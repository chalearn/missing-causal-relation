 function [a] = corrt_test(d,ntrain,ntest,alpha,l) 

%====================================================================================================
% corrected resampled t-test object - significance test of results
%==================================================================================================== 
%  A=corrt_test(D,ntrain,ntest,ntrials,alpha,[L]) calculates the statistical significance of the mean
%  loss being equal to competitors for groups of results (data objects)
%  D, with loss function/type L.  
%
%  NOTE: Assumes you have the Matlab stats package, uses tinv.
%
%  Examples:
%    d=gen(toy);
%    corrt_test(train(cv({svm knn}),d),40,10,0.05)   % or is equivalent to below  
%    train(corrt_test(cv({svm knn}),40,10,0.05),d)   % or is equivalent to below  
%    corrt=corrt_test; corrt.ntrain=40; corrt.ntest=10; corrt.alpha=0.05;
%    train(chain({ group(cv({svm knn}),'all') corrt  }),d)
%
%====================================================================================================
% Reference : 
% Author    : 
% Link      : 
%==================================================================================================== 
  a.ntrain=[];
  a.ntest=[];
  a.alpha=[]; 

  
  %% --------- don't make object : calculate corrt_test like function --------
  if nargin>0 & isa(d,'algorithm') & d.is_data %% input data - return result
    a=corrt_test; 
    a.ntrain=ntrain; a.ntest=ntest; a.alpha=alpha; 
    if nargin==5 a.loss_type=l; end; d.group='all';
    a=train(a,d);
    return;
  end 
  %% --------------------------------------------------------------------
  
  if nargin>0
    a.ntrain=ntrain; a.ntest=ntest; a.alpha=alpha; 
  end
  
  a.loss_type=[]; a.child=[];
  if nargin>0  
    if isa(d,'algorithm') 
      a.child=d;
      if nargin>4 a.loss_type=l; end;
    else
      if nargin>0 a.loss_type=d; end;
    end
  end;
  p=algorithm('corrt_test');
  a= class(a,'corrt_test',p);
   

