function [dat] =  test(algo,dat,lossType)
% 
%               [res]=test(algo,data,loss) 
%   An algorihm algo is trained on the training set data. If a loss
%   function is supplied, it will be calculated.
%   It returns a data object containing the results.
%   If no loss function is supplied, the data object will contain the loss
%   on the training set. If not, it usually contain the label estimates in
%   the X part and the true labels in the Y part of the data object.
%
%   It is also possible to call test(algo), where the emtpy data set is passed 
%   into the algorithm to test it. This is useful for methods that generate their
%   own data.
%   
%   Note: 
%               test(algo) <=> test(algo,[]).

%% Programming note:
% It is used to call testing.m function which doesn't include loss
% function calculations in a child object 

    
if nargin==1 
    dat=[];% <--- data is optional
end; 

if nargin<3 
    lossType=[]; 
end; 

if iscell(dat) 
    dat=group(dat); 
end;
%%<<----test data---->>
if ~isempty(dat) 
    if ~am_i_data(dat)  
        dat=test(dat); %% <--- i.e generate data 
    end
end

%%%% SGE support (note sightly different behaviour from algorithm/train)
if isdeferred(algo)
	if submitted(algo.deferred)
		[algo jobfailed] = waitcollect(algo);
		if jobfailed, return, end
	else
		dat.deferred = qsub(algo.deferred, max(nargout,1), mfilename, algo, dat, lossType);
		return
	end
end
if ~isempty(dat)
if isdeferred(dat)
	[dat jobfailed] = waitcollect(dat);
	if jobfailed, return, end
end 
end
%%%%
warning off
e=struct(dat);
warning on
%%<<------ if there are multiple datasets as input ---->>
if isa(dat,'group')  & strcmp(e.group,'separate') 
  dat=e.child; % dat seen as @algorithm object => so it is not possible to access child directly
  dat=make_cell(dat);
  res=[];
  for i=1:length(dat)
      [r]=test(algo,dat{i},lossType); 
      res{i}=r;
  end
  dat=group(res);  %% <--- return data/res as set of group
else
    %%%% IG: Implement Amir's idea to monitor progression
    [p, n]=get_dim(dat);
    a=struct(algo);
    p0=round(max(p/10, a.algorithm.maxsize/n));
    %p0=round(a.algorithm.maxsize/n);
    if p > p0
        if a.algorithm.verbosity>0
            fprintf(['testing ' a.algorithm.name '... ']);
        end
        X=[];
        tic
        for k=1:p0:p
            kp=min(k+p0-1,p);
            rng=k:kp;
            dt = get(dat,rng); 
            dt=testing(algo,dt);
            if k==1 & issparse(get_x(dt)), X=sparse(X); end % IG Feb 7, 2006
            X(rng,:)=get_x(dt);
            if a.algorithm.verbosity>0
                fprintf('%d%%(%5.2f sec) ', round(100*kp/p), toc);
            end
        end
        dat=set_x(dat, X);
        if a.algorithm.verbosity>0
            fprintf('... done\n');
        end
    else
        dat=testing(algo,dat);
    end

    %%% End IG
    if ~isempty(lossType) 
      if isa(lossType,'loss')
	dat=train(lossType,dat);
      else
	dat=loss(dat,lossType);
      end
    end;    
    if iscell(dat) 
        dat=group(dat); 
    end;  %%  <--- return data/res as set of group
end



