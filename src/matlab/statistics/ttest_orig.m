function [ t_stat, p_value ] = ttest_orig ( s, f, t, gi )
%TTEST_ORIG Summary of this function goes here
%   Detailed explanation goes here
%   s   ->  Source variable.
%   f   ->  Linear regression used to imput the source missing values.
%   t   ->  Target variable.
%   gi  ->  Array with good element positions (position of no missing value
%           elements) in s variable.

    classes = unique(t);
    n1 = sum(t==classes(1)); 
    n2 = sum(t==classes(2));

    %% Calculate the s_hat variable (s with imputation by linear regression)
    ar_gi = zeros(size(s,1),1);
    ar_gi(gi)=1;
    s_hat([find(ar_gi); find(ar_gi==0)]) = [s(find(ar_gi)); f(find(ar_gi==0))];
    s_hat = s_hat';
    
    %% Compute the difference between the means of the 2 classes (defined by T) for F abs(mu1-mu2)
    tn = abs(mean(s_hat(t==1)) - mean(s_hat(t==-1)));

    %% Compute the original T statistic abs(mu1-mu2) / sigma to independent variables with equal sample sizes and equal variance
    
    sigma_pooled1 = std(s_hat(t==1));
    sigma_pooled2 = std(s_hat(t==-1));

    % Denominator of the original t-stat
    td = sqrt(2/n1) * sqrt((sigma_pooled1^2+sigma_pooled2^2)/2);

    % Compute the original t-stat
    t_stat = tn/td;

    % Get the p-value of the statistic
    p_value = (1-tcdf (t_stat,2*n1-2))*2;

end