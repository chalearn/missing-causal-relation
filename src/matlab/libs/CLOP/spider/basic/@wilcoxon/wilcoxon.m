 function [a] = wilcoxon(dat,lss) 

%===========================================================================
% Wilcoxon object - significance test of results
%=========================================================================== 
%  A=wilcoxon(D,[L]) calculates the statistical significance of the median
%  loss being greater than competitors for groups of results (data objects)
%  D, with loss function/type L.  
%
%  NOTE: Assumes you have the Matlab stats package, uses signrank.
%
%  Examples:
%    d=gen(toy);
%    wilcoxon(train(cv({svm knn}),d))   % or is equivalent to below  
%    train(wilcoxon(cv({svm knn})),d)   % or is equivalent to below  
%    train(chain({ group(cv({svm knn}),'all') wilcoxon  }),d)
%===========================================================================
% Reference : 
% Author    : 
% Link      : 
%=========================================================================== 
  
  %% --------- don't make object : calculate wilcoxon like function --------
  if nargin>0 & isa(dat,'algorithm') 
      if dat.is_data %% input data - return result
        a=wilcoxon; 
            if nargin==2 
                a.loss_type=lss; 
            end; 
            dat.group='all';
            a=train(a,dat);
            return;
        end
  end 
  %% --------------------------------------------------------------------
  
  a.loss_type=[]; 
  a.child=[];
  if nargin>0  
    if isa(dat,'algorithm') 
      a.child=dat;
      if nargin>1 a.loss_type=lss; end;
    else
      if nargin>0 a.loss_type=dat; end;
    end
  end;
  p=algorithm('wilcoxon');
  a= class(a,'wilcoxon',p);
   

