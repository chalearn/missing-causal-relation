function [ output_args ] = plot_pvalue_ev(t_stat_list, delta_mu_val, p_value, std_value)
%PLOT_CAUSAL_MODEL_GRAPH Summary of this function goes here
%   Detailed explanation goes here

    n_subplot = size(t_stat_list,2);
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
    switch nargin
        case 4
            for s=1:n_subplot
                subplot(n_row,n_col,s)
                hold on
                errorbar(delta_mu_val, p_value(s,:), std_value(s,:));
                plot(delta_mu_val,ones(1,length(delta_mu_val))*0.05,'g-');
                hold off
                xlim([delta_mu_val(1) delta_mu_val(end)]);
                ylim([-0.2 1]);
                xlabel('Class separation');
                ylabel('Partial correlation')
                title(['METHOD: ' t_stat_list{s}])
            end
        case 3
            plot(delta_mu_val,p_value(1,:),'k-', ...
                 delta_mu_val,p_value(2,:),'b-', ...
                 delta_mu_val,p_value(3,:),'b:', ...
                 delta_mu_val,p_value(4,:),'r-', ...
                 delta_mu_val,p_value(5,:),'r--', ...
                 delta_mu_val,p_value(6,:),'r:', ...
                 delta_mu_val,ones(1,length(delta_mu_val))*0.05,'g-');

            xlim([delta_mu_val(1) delta_mu_val(end)]);
            ylim([-0.2 1]);
            title('P-value evolution');
            xlabel('Class separation');
            ylabel('P-value');
            legend(t_stat_list);
        otherwise
    end
end

