function bias = bias_optimize(Output, Target, option)
% bias = bias_optimize(Output, Target, option)
% Find the bias that optimizes the balanced error rate.
% Inputs:
% Output    -- matrix m x c of outputs for each of the c classes
% Target    -- +- corresponding target values
% option    -- 1: minimum of the BER; 2: break-even-point between
% sensitivity and specificity; 3: average of the two previous results if
% they do not differ a lot, otherwise zero.
% bias      -- optimum bias for best balanced error rate

% Isabelle Guyon -- October 2003 -- isabelle@clopinet.com

debug=0;

Posidx = find(Target>0);
Negidx = find(Target<0);
Posout = Output(Posidx);
Negout = Output(Negidx);
Sposout = sort(Posout);
Snegout = sort(Negout);

% Algorithm to compute berrate
soutval=sort(unique(Output));
midval=0.5*(soutval(2:length(soutval))+soutval(1:length(soutval)-1));
midval=[soutval(1); midval; soutval(length(soutval))];
poserr=zeros(size(midval));
negerr=zeros(size(midval));
ln=length(Snegout);
lp=length(Sposout);
j=1;
poserr(1)=0;
for i=2:length(midval)
    poserr(i)=poserr(i-1);
    while(j<=length(Sposout) & Sposout(j)<midval(i))
        poserr(i)=poserr(i)+1;
        j=j+1;
    end
end
poserr(i)=lp;
j=length(Snegout);
negerr(length(negerr))=0;
for i=length(midval)-1:-1:1
    negerr(i)=negerr(i+1);
    while(j>0 & Snegout(j)>midval(i))
        negerr(i)=negerr(i)+1;
        j=j-1;
    end
end
negerr(i)=ln;

perrate=poserr/lp;
nerrate=negerr/ln;
berrate=0.5*(perrate+nerrate);
break_even=abs(nerrate-perrate);

if debug
	figure;
	plot(Snegout,1-(1/ln:1/ln:1),'r-',Sposout,1-(1:-1/lp:1/lp),'b-');
	ylabel('Pos class errate (blue) and Neg class errate (red) Berrate (black)');
	xlabel('threshold');
	hold on; plot(midval, perrate, 'b--', midval, nerrate, 'r--', midval, berrate, 'k');
	hold on; plot(midval, break_even, 'k--');
end

% Find the best threshold
% 1) as the minimum of the balanced error rate
bm=min(berrate);
good_idx=find(berrate==bm);
theta_min_berrate=median(midval(good_idx));
% 2) as the break even point between sensitivity and specificity
bm=min(break_even);
good_idx=find(break_even==bm);
theta_break_even=median(midval(good_idx));

% Consistency check
delta_theta=abs(theta_min_berrate-theta_break_even);
rngval=range(midval);
rngval(rngval==0)=1;
if (delta_theta/rngval<0.1)
    theta_consensus=(theta_min_berrate+theta_break_even)/2;
else
    theta_consensus=0;
end

switch option
    case 1 % This works well with naive Bayes
        theta=theta_min_berrate;
    case 2
        theta=theta_break_even;
    case 3
        theta=theta_consensus;
end

if debug
    title(['Theta = ' num2str(theta)]);
end
bias=-theta;

return