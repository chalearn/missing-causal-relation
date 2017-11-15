% This script examplifies the effect of various ways of dealing with missing
% values on variable selection with the T-test.
clear all
clc
addpath('CLOP');
use_spider_clop;

% For the sake of simplicity, we only have 3 variables:
% Two continuous "features" and one "target" variable.
% One of the features is fully observed (no missing data) and is used to
% "help" another variable that has missing data, which we call "source".
% We are interested in studying how we can determine whether the "source"
% variable and the target are significantly dependent. We will use a
% variant of the T-statistic to measure that dependence.

%T->S->H

%% VARIABLE INITIALIZATION SECTION
% Missing fraction.
frac_missing = 0.8;
% Number of repetitions of the experiment to obtain more stable results.
repeats = 100;
% Array with delta_mu values that indicate the separation between classes.
max_delta_mu = 2;
delta_mu_step=0.1;
delta_mu_val = delta_mu_step:delta_mu_step:max_delta_mu;

% Obtain basic info about statistic and correlation names.
[t_stat_list, p_corr_list] = basic_info();
n_t_stat = length(t_stat_list);
n_p_corr = length(p_corr_list);

t_statistic_r = zeros(repeats,length(delta_mu_val),n_t_stat);
p_value_r = zeros(repeats,length(delta_mu_val),n_t_stat);
t_stat_par_corr_r = zeros(repeats,length(delta_mu_val),n_p_corr);
p_value_par_corr_r = zeros(repeats,length(delta_mu_val),n_p_corr);

t_statistic = zeros(n_t_stat,length(delta_mu_val));
t_statistic_mean = zeros(n_t_stat,length(delta_mu_val));
t_statistic_std = zeros(n_t_stat,length(delta_mu_val));
p_value = zeros(n_t_stat,length(delta_mu_val));
p_value_mean = zeros(n_t_stat,length(delta_mu_val));
p_value_std = zeros(n_t_stat,length(delta_mu_val));

t_statistic_h_t = zeros(1,length(delta_mu_val));
t_statistic_h_t_mean = zeros(1,length(delta_mu_val));
t_statistic_h_t_std = zeros(1,length(delta_mu_val));
p_value_h_t = zeros(1,length(delta_mu_val));
p_value_h_t_mean = zeros(1,length(delta_mu_val));
p_value_h_t_std = zeros(1,length(delta_mu_val));

p_corr_mean = zeros(n_p_corr,length(delta_mu_val));
p_corr_std = zeros(n_p_corr,length(delta_mu_val));

corr_table = cell(1,length(delta_mu_val));
corr_table_list_wise = cell(1,length(delta_mu_val));

%% EXPERIMENTATION SECTION
for d=1:length(delta_mu_val)
    delta_mu=delta_mu_val(d);
    corr_table_r = zeros(5,5,repeats);
    for r=1:repeats
        %% Generate variables S, H and T according to causal relationship model.
        % The target variable has n1 examaples of the positive class and n2
        % examples of the negative class.
        n1=50;
        n2=50;
        target = [ones(n1,1); -ones(n2,1)];
        % The "source" variable is a Gaussian mixture.
        % The samples for each class are Gaussian distributed with standard 
        % deviations s1 and s2, and means m1 and m2 separated by delta_mu
        alpha = 1; % signal to noise ratio
        mu1=alpha*delta_mu/2;
        mu2=-alpha*delta_mu/2;
        s1=delta_mu;
        s2=delta_mu;
        source = [s1*randn(n1,1)+mu1; s2*randn(n2,1)+mu2];
        % The helper variable, correlated with the source, has no missing values
        a = 1; % slope
        b = 0; % intercept
        noise_level = delta_mu/2;
        noise = randn(n1+n2, 1)*noise_level;
        helper = a * source + b + noise;

        %% Generate missing data with the same sample size of missing in each class.
        idx1=find(target==1);
        idx2=find(target==-1);
        aux_idx1 = idx1(randperm(n1));
        aux_idx2 = idx2(randperm(n2));
        miss_idx1 = aux_idx1(1:n1*frac_missing);
        miss_idx2 = aux_idx2(1:n2*frac_missing);
        good_idx1 = aux_idx1(n1*frac_missing+1:end);
        good_idx2 = aux_idx2(n2*frac_missing+1:end);
        good_idx = union(good_idx1, good_idx2);
        miss_idx = union(miss_idx1, miss_idx2);

        %% Perform a linear regression of H on S with non missing data F(H) = aH + b
        [p,S,mu] = polyfit(helper(good_idx),source(good_idx),1);

        %% Compute the residual for the non missing values sigma_res = sqrt[sum_i((F(Hi)-Si)^2]
        % To see how good the fit is, evaluate the polynomial at the data 
        % points and generate a table showing the data, fit, and error.
        f = polyval(p,helper);
        T = table(helper(good_idx), source(good_idx),f(good_idx), ...
                  source(good_idx)-f(good_idx), 'VariableNames', ...
                  {'X','Y','Fit','FitError'});
        s_hat([good_idx; miss_idx]) = [source(good_idx); f(miss_idx)]; 
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Uncomment following lines to show distribution data graphs.
        % Notice that these lines are inside a big loop and can generate a
        % lot of graphs and consume a lot of CPU time.
        %figure;
        %subplot(1,3,1)
        %title('Data without missing values')
        %scatterplot([helper, source], target, 0);
        %subplot(1,3,2)
        %title('Data with missing values')
        %target_miss_class_plot = target;
        %target_miss_class_plot(miss_idx1) = 2;
        %target_miss_class_plot(miss_idx2) = -2;
        %scatterplot([helper, source], target_miss_class_plot, 0);
        %subplot(1,3,3)
        %title('Data with imputation values')
        %scatterplot([helper, s_hat'], target_miss_class_plot, 1);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %% Compute different t-statistics between variables.
        [ t_statistic_nomissing(r), p_value_nomissing(r) ] = ttest_nomissing ( source, target );
        [ t_statistic_listwise(r), p_value_listwise(r) ] = ttest_listwise( source, good_idx1, good_idx2 );
        s_mean_imput = source;
        s_mean_imput(miss_idx) = mean(s_mean_imput(good_idx));
        [ t_statistic_meanimput(r), p_value_meanimput(r) ] = ttest_meanimput ( s_mean_imput, target );
        [ t_statistic_orig(r), p_value_orig(r) ] = ttest_orig ( source, f, target, good_idx );
        [ t_statistic_modif(r), p_value_modif(r) ] = ttest_mod ( source, f, target, good_idx );
        [ t_statistic_kristin(r), p_value_kristin(r) ] = ttest_kristin( source, f, target, good_idx, frac_missing, noise );
        [ t_statistic_h_t_r(r), p_value_h_t_r(r) ] = ttest_nomissing ( helper, target );

        %% Compute correlation coeficient between variables.
        corr_table_r(:,:,r) = corrcoef([source s_mean_imput s_hat' helper target]);
        corr_table_list_wise_r(:,:,r) = corrcoef([source(good_idx) s_mean_imput(good_idx) s_hat(good_idx)' helper(good_idx) target(good_idx)]);
        [t_stat_par_corr(r,1), p_value_par_corr(r,1)] = partialcorr(source,target,helper); %between S and T removing effect of H
        [t_stat_par_corr(r,2), p_value_par_corr(r,2)] = partialcorr(source,helper,target); %between S and H removing effect of T
        [t_stat_par_corr(r,3), p_value_par_corr(r,3)] = partialcorr(helper,target,source); %between H and T removing effect of S
        [t_stat_par_corr(r,4), p_value_par_corr(r,4)] = partialcorr(s_mean_imput,target,helper); %between S with mean imput and T removing effect of H
        [t_stat_par_corr(r,5), p_value_par_corr(r,5)] = partialcorr(s_mean_imput,helper,target); %between S with mean imput and H removing effect of T
        [t_stat_par_corr(r,6), p_value_par_corr(r,6)] = partialcorr(helper,target,s_mean_imput); %between H and T removing effect of S with mean imput
        [t_stat_par_corr(r,7), p_value_par_corr(r,7)] = partialcorr(source(good_idx),target(good_idx),helper(good_idx)); %between S with list-wise delention and T removing effect of H
        [t_stat_par_corr(r,8), p_value_par_corr(r,8)] = partialcorr(source(good_idx),helper(good_idx),target(good_idx)); %between S with list-wise delention and H removing effect of T
        [t_stat_par_corr(r,9), p_value_par_corr(r,9)] = partialcorr(helper(good_idx),target(good_idx),source(good_idx)); %between H and T removing effect of S with mean imput
        [t_stat_par_corr(r,10), p_value_par_corr(r,10)] = partialcorr(s_hat',target,helper); %between S with linear regression and T removing effect of H
        [t_stat_par_corr(r,11), p_value_par_corr(r,11)] = partialcorr(s_hat',helper,target); %between S with linear regression and H removing effect of T
        [t_stat_par_corr(r,12), p_value_par_corr(r,12)] = partialcorr(helper,target,s_hat'); %between H and T removing effect of S with linear regression
    end
    
    %% Simplification of the results obtained in the different repetitions of same experiment.
    t_statistic_r(:,d,1) = t_statistic_nomissing';
    t_statistic_r(:,d,2) = t_statistic_listwise';
    t_statistic_r(:,d,3) = t_statistic_meanimput';
    t_statistic_r(:,d,4) = t_statistic_orig';
    t_statistic_r(:,d,5) = t_statistic_modif';
    t_statistic_r(:,d,6) = t_statistic_kristin';
    
    p_value_r(:,d,1) = p_value_nomissing';
    p_value_r(:,d,2) = p_value_listwise';
    p_value_r(:,d,3) = p_value_meanimput';
    p_value_r(:,d,4) = p_value_orig';
    p_value_r(:,d,5) = p_value_modif';
    p_value_r(:,d,6) = p_value_kristin';
    
    for i=1:n_p_corr
        t_stat_par_corr_r(:,d,i) = t_stat_par_corr(:,i);
        p_value_par_corr_r(:,d,i) = p_value_par_corr(:,i);
    end
        
    t_statistic(:,d) = squeeze(median(t_statistic_r(:,d,:)));
    t_statistic_mean(:,d) = squeeze(mean(t_statistic_r(:,d,:)));
    t_statistic_std(:,d) = squeeze(std(t_statistic_r(:,d,:)));
    p_value(:,d) = squeeze(median(p_value_r(:,d,:)));
    p_value_mean(:,d) = squeeze(mean(p_value_r(:,d,:)));
    p_value_std(:,d) = squeeze(std(p_value_r(:,d,:)));
    
    t_statistic_par_corr_mean(:,d) = squeeze(mean(t_stat_par_corr_r(:,d,:)));
    t_statistic_par_corr_std(:,d) = squeeze(std(t_stat_par_corr_r(:,d,:)));
    p_value_par_corr_mean(:,d) = squeeze(mean(p_value_par_corr_r(:,d,:)));
    p_value_par_corr_std(:,d) = squeeze(std(p_value_par_corr_r(:,d,:)));

    t_statistic_h_t(1,d) = median(t_statistic_h_t_r');
    t_statistic_h_t_mean(1,d) = mean(t_statistic_h_t_r');
    t_statistic_h_t_std(1,d) = std(t_statistic_h_t_r');
    p_value_h_t(1,d) = median(p_value_h_t_r');
    p_value_h_t_mean(1,d) = mean(p_value_h_t_r');
    p_value_h_t_std(1,d) = std(p_value_h_t_r');

    corr_table{1,d} = median(corr_table_r,3);
    corr_table_list_wise{1,d} = median(corr_table_list_wise_r,3);
end

%% PLOT RESULTS SECTION
plot_pvalue_ev(t_stat_list, delta_mu_val, p_value);
plot_pvalue_ev(t_stat_list, delta_mu_val, p_value_mean, p_value_std);
plot_h0_reject_hist( t_stat_list, delta_mu_val, p_value_r, repeats );

plot_partial_corr( p_corr_list, delta_mu_val, t_statistic_par_corr_mean, t_statistic_par_corr_std);
plot_h0_reject_hist_partial_corr( p_corr_list, delta_mu_val, p_value_par_corr_r, repeats );