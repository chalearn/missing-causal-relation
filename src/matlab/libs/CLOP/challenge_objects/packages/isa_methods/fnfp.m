function [m_margin,e_margin,err_num,rej_num,err_idx,rej_idx] = fnfp(Output, Target, silent, sim_name)
% [m_margin,e_margin,err_num,rej_num,err_idx,rej_idx] = fnfp(Output, Target, silent, sim_name)
% False negative/false positive curves
% Output: matrix m x c of outputs for each of the c classes
% Target: +- corresponding target values
% silent: a flag not to display the curve is 1
% sim_name: a string to identify the figure
% m_margin=median margin
% e_margin=extremal margin
% err_num=number of errors at zero reject
% rej_num=number of rejected at zero error
% err_idx=indices of errors
% rej_idx=indices of rejected

% Isabelle Guyon -- March 2003 -- isabelle@clopinet.com

if nargin<3, silent=0; end
if nargin<4, sim_name=''; end

m=length(Output);

Posidx = find(Target>0);
Negidx = find(Target<0);
Posout = Output(Posidx);
Negout = Output(Negidx);
Sposout = sort(Posout);
Snegout = sort(Negout);

% Median margin
medneg=median(Snegout);
medpos=median(Sposout);
maxpos=max(Sposout);
minneg=min(Snegout);
maxall=max(Output);
minall=min(Output);
%m_margin=(medpos-medneg)/abs(maxpos-minneg);
if(maxall==minall)
   m_margin=0;
else
   m_margin=(medpos-medneg)/abs(maxall-minall);
end



% Extremal margin
maxneg=max(Snegout);
minpos=min(Sposout);
%e_margin=(minpos-maxneg)/abs(maxpos-minneg);
if(maxall==minall)
   e_margin=0;
else
   e_margin=(minpos-maxneg)/abs(maxall-minall);
end

% Number of errors at zero rejection
err_idx = union(Posidx(find(Posout<=0)),Negidx(find(Negout>=0)));
err_num = length(err_idx);

% Number of rejections at zero error
rej_num=0;
if err_num==0, 
   rej_num=0; 
   rej_idx=[];
elseif e_margin>0,
   theta = min(abs(maxneg),abs(minpos));
   rej_idx = union(Posidx(find(Posout<=theta)),Negidx(find(Negout>=-theta)));
   rej_num = length(rej_idx);
else
   theta = max(abs(maxneg),abs(minpos));
   if ~isempty(theta)
       rej_idx = union(Posidx(find(Posout<=theta)),Negidx(find(Negout>=-theta)));
       rej_num = length(rej_idx);
   end
end
   
   
if ~silent 
   figure('Name', [sim_name ' fn/fp curves']);
 	plot(Snegout,length(Snegout):-1:1,'r-',Sposout,1:length(Sposout),'b-');
   xlabel('threshold');
   ylabel('number of false negative (blue) / false positive (red)');
   title(['tot. trial=', num2str(m), ', err. num.(0 rej)=',num2str(err_num), ', rej. num.(0 err)=',num2str(rej_num),...
            ', ext. marg.= ', num2str(round(100*e_margin)/100), ...
            ', med. marg.=', num2str(round(100*m_margin)/100)]);
    
    figure('Name', [sim_name ' sensitivity and specificity']);
    ln=length(Snegout);
    lp=length(Sposout);
    plot(Snegout,1/ln:1/ln:1,'r-',Sposout,1:-1/lp:1/lp,'b-');
    ylabel('Sensitivity (blue) and Specificity (red)');
    xlabel('threshold');
end

return


