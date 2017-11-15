function [errate, fnrate, fprate, mcrate, Error_idx, Fn_idx, Fp_idx] = svc_stat(Output, Target, theta1, theta2, show_fafr)
%[errate, fnrate, fprate, mcrate, Error_idx, Fn_idx, Fp_idx] = svc_stat(Output, Target)
% Calculate error statistics given:
% 		Output -- [p,c] matrix of outputs
% 		Target -- [p,c] matrix of -1 and 1
% Optional:
%		theta1 -- Absolute rejection threshold
%		theta2 -- Differential rejection threshold
%		show_fafr -- flag: 0=nothing, 1=show false accpeted/false rejected curves
% Returns:
% 		errate -- error rate
% 		fnrate -- false negative (rejected) fraction of errors
% 		fprate -- false positive (accepted) fraction of errors
%		mcrate -- misclassified fraction of errors
%     Error_idx -- Indices of the errors, if the target vector is precised.
%     Fn_idx -- Indices of false negative (rejected), if the target vector is precised.
%     Fp_idx -- Indices of false positive (accepted), if the target vector is precised.

if(nargin<3), help svc_stat; error('Too few arguments'); end
if(nargin<3 | isempty(theta1)), theta1=0; end
if(nargin<4 | isempty(theta2)), theta2=0.5; end
if(nargin<5 | isempty(show_fafr)), show_fafr=0; end

[p,c]=size(Output);
[pp,cc]=size(Target);
if(p~=pp | c~=cc), error('Incompatible matrix size'); end
% Compute the targets
[Targmax,Targclass] = max(Target,[],2);
Targclass(Targmax<0)=0; % Reject class is zero (all negative targets)
% Compute maximum
[Outmax,Outclass] = max(Output,[],2);
% Compute difference with second maximum
Doutput=repmat(Outmax,1,c)-Output;
Doutput(Doutput==0)=Inf;
[Doutmax,Doutclass] = min(Doutput,[],2);
% Decide about rejections
Outclass(Outmax<theta1)=0;
Outclass(Doutmax<theta2)=0;
% Compare both
Error_idx = find(Outclass~=Targclass);
tp = length(Outclass);
ep = length(Error_idx);
errate = ep/tp;
fnrate=0; fprate=0; mcrate=0;
Fn_idx=[]; Fp_idx=[];
if(errate~=0),
	Fn_idx = find(Targclass>0 & Outclass==0);
	Fp_idx = find(Targclass==0 & Outclass>0);
	fnrate = length(Fn_idx)/ep;
	fprate = length(Fp_idx)/ep;
   mcrate = 1-fnrate-fprate;
end

% False accepted/rejected curves
if(show_fafr),
	% Absolute threshold
	Posidx = find(Targclass>0);
	Negidx = find(Targclass==0);
	Posout = Outmax(Posidx);
	Negout = Outmax(Negidx);
	Sposout = sort(Posout);
   Snegout = sort(Negout); 
   medneg=median(Snegout);
   medpos=median(Sposout);
   maxpos=max(Sposout);
   minneg=min(Snegout);
   m_margin=(medpos-medneg)/(maxpos-minneg);
   maxneg=max(Snegout);
   minpos=min(Sposout);
   e_margin=(minpos-maxneg)/(maxpos-minneg);
	figure('Name', 'Absolute threshold');
	plot(Snegout,length(Snegout):-1:1,'b-',Sposout,1:length(Sposout),'r-');
	title(['FA/FR curves (extremal margin=', num2str(e_margin), ', median margin=', num2str(m_margin),')']);
	xlabel('threshold');
   ylabel('Number of false accepted (blue)/false rejected (red)');
   if(c>1)
		% Relative threshold
		Dposout = Doutmax(Posidx);
		Dnegout = Doutmax(Negidx);
		Sposout = sort(Dposout);
		Snegout = sort(Dnegout); 
		figure('Name', 'Relative threshold');
		plot(Snegout,length(Snegout):-1:1,'b-',Sposout,1:length(Sposout),'r-');
		title('FA/FR curves');
		xlabel('threshold');
      ylabel('Number of false accepted (blue)/false rejected (red)');
   end
end

