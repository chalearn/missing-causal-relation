function [ output_args ] = plot_partial_corr( p_corr_list, delta_mu_val, pcorr_m, pcorr_s)
%PLOT_PARTIAL_CORR Summary of this function goes here
%   Detailed explanation goes here

n_subplot = size(pcorr_m,1);
n_row = n_subplot;
n_col = 1;
if (mod(n_subplot,3)==0)
    n_row = n_subplot/3;
    n_col = 3;
else if (mod(n_subplot,4)==0)
    n_row = n_subplot/4;
    n_col = 4;
else if (mod(n_subplot,2)==0)
    n_row = n_subplot/2;
    n_col = 2;
else if (mod(n_subplot,5)==0)
    n_row = n_subplot/5;
    n_col = 5;    
end
end
end
end

figure
for s=1:n_subplot
    subplot(n_row,n_col,s)
    errorbar(delta_mu_val, pcorr_m(s,:), pcorr_s(s,:));
    xlim([delta_mu_val(1) delta_mu_val(end)]);
    ylim([-1 1]);
    xlabel('Class separation');
    ylabel('Partial correlation')
    title(p_corr_list{s})
end