function [ t_stat, p_value ] = ttest_kristin( s, f, t, gi, fm, rn )
%TTEST_KRISTIN Summary of this function goes here
%   Detailed explanation goes here
%   s   ->  Source variable.
%   f   ->  Linear regression used to imput the source missing values.
%   t   ->  Target variable.
%   gi  ->  Array with good element positions (position of no missing value
%           elements) in s variable.
%   fm  ->  Fraction of missing values
%   rn  ->  Noise of the linear regression

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

    %% Compute the modify T statistic for fixed A developed by Kristin.
    
    cov1 = cov(s_hat(t==1));
    cov2 = cov(s_hat(t==-1));

    % Denominator of the modified t-stat
    td=sqrt(cov1/n1 + cov2/n2 + ...
            ((n1*fm)/n1^2 + (n2*fm)/n2^2)*sum(rn)^2);

    % Compute the modified t-stat
    t_stat = tn/td;
    
    % Get the p-value of the statistic
    p_value = (1-tcdf (t_stat,2*n1-2))*2;

end