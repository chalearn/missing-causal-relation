function [ t_stat, p_value ] = ttest_listwise( s, gi1, gi2 )
%TTEST_LISTWISE Summary of this function goes here
%   Detailed explanation goes here
%   s   ->  Source variable.
%   gi1 ->  Array position of good class1 elements in f variable
%           1   -> indicates a original source element that dit not suffer loss
%           0   -> indicates a missing element imput by a mechanism.
%   gi2 ->  Array position of good class2 elements in f variable
%           1   -> indicates a original source element that dit not suffer loss
%           0   -> indicates a missing element imput by a mechanism.

    %% Compute the difference between the means of the 2 classes (defined by T) for F abs(m1-nu2)
    tn = abs(mean(s(gi1)) - mean(s(gi2)));

    %% Compute the original T statistic abs(mu1-mu2) / sigma to independent variables with equal sample sizes and equal variance

    sigma_pooled1 = std(s(gi1));
    sigma_pooled2 = std(s(gi2));

    % Denominator of the original t-stat
    td = sqrt(2/length(gi1)) * sqrt((sigma_pooled1^2+sigma_pooled2^2)/2);

    % Compute the original t-stat
    t_stat = tn/td;

    % Get the p-value of the statistic
    p_value = (1-tcdf (t_stat,2*length(gi1)-2))*2;

end