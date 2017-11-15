function [ output_args ] = plot_h0_reject_hist_partial_corr( p_corr_list, delta_mu_val, p_value_par_corr, repeats )
%PLOT_H0_REJECT_HIST_PARTIAL_CORR Summary of this function goes here
%   Detailed explanation goes here

n_p_corr = length(p_corr_list);
n_row = n_p_corr;
n_col = 1;
if (mod(n_p_corr,3)==0)
    n_row = n_p_corr/3;
    n_col = 3;
else if (mod(n_p_corr,4)==0)
    n_row = n_p_corr/4;
    n_col = 4;
else if (mod(n_p_corr,2)==0)
    n_row = n_p_corr/2;
    n_col = 2;
else if (mod(n_p_corr,5)==0)
    n_row = n_p_corr/5;
    n_col = 5;    
end
end
end
end

figure
h = repmat(delta_mu_val,repeats,1,n_p_corr).*(p_value_par_corr<0.025); %two-tailed
for s=1:n_p_corr
    subplot(n_row,n_col,s)
    hi = histogram(h(:,:,s),delta_mu_val);
    hi.NumBins=length(delta_mu_val);
    ylim([0 repeats])
    xlim([delta_mu_val(1) delta_mu_val(end)])
    xlabel('Class separation');
    ylabel('Num. of rejected H0')
    title(p_corr_list{s})
end


end

