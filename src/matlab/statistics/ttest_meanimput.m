function [ t_stat, p_value ] = ttest_meanimput( s, t )
%TTEST_MEANIMPUT Summary of this function goes here
%   Detailed explanation goes here

classes = unique(t);
n1 = sum(t==classes(1)); 
n2 = sum(t==classes(2));

%% Compute the difference between the means of the 2 classes (defined by T) for F(H) abs(m1-nu2)
% Notice this uses the F(H) “reconstructed” values for all samples, even for non missing data
tn = abs(mean(s(t==1)) - mean(s(t==-1)));

%sigma_pooled^2 is the pooled within class variance (you may use (sigma1^2 +  sigma2^2)/2 if the classes are balanced)
sigma_pooled1 = std(s(t==1));
sigma_pooled2 = std(s(t==-1));

% Denominator of the original t-stat
td = sqrt(2/n1) * sqrt((sigma_pooled1^2+sigma_pooled2^2)/2);

% Compute the original t-stat
t_stat = tn/td;
% Get the p-value of the statistic
p_value = (1-tcdf (t_stat,2*n1-2))*2;


end

