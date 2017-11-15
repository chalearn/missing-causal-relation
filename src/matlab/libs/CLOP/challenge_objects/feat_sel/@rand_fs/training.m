function [dat, a] =  training(a,dat)
%[dat, a] =  training(a,dat)
% Selects features at random

% Isabelle Guyon -- isabelle@clopinet.com -- September 2005

[p, n]=size(dat.X);

a.f_max=min(n, a.f_max);

rp=randperm(n);
a.fidx=rp(1:length(a.f_max))';
a.W=ones(n, 1);
  
  dat=test(a, dat);
  

  

  
  
