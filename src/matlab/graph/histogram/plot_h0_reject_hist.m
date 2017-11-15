function [ output_args ] = plot_h0_reject_hist( t_stat_list, delta_mu_val, p_value_r, repeats )
%PLOT_HIST Summary of this function goes here
%   Detailed explanation goes here


n_t_stat = length(t_stat_list);

figure
h = repmat(delta_mu_val,repeats,1,n_t_stat).*(p_value_r<0.05);
for s=1:n_t_stat
    subplot(2,3,s)
    hi = histogram(h(:,:,s),delta_mu_val);
    hi.NumBins=length(delta_mu_val);
    ylim([0 repeats])
    xlim([delta_mu_val(1) delta_mu_val(end)])
    xlabel('Class separation');
    ylabel('Num. of rejected H0')
    title(['METHOD: ' t_stat_list{s}])
end

end

