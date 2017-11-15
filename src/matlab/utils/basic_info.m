function [ t_stat_list, p_corr_list ] = basic_info()
    t_stat_list= {'No missing', 'List-wise del.', 'Mean imput.', ...
                  'Linear reg. imput. - Orig. T-stat', ...
                  'Linear reg. imput. - Var1 T-stat', ...
                  'Linear reg. imput. - Var2 T-stat'};

    p_corr_list= {'Part. corr. S and T removing H', ...
                  'Part. corr. S and H removing T', ...
                  'Part. corr. H and T removing S', ...
                  'Part. corr. S mean imput. and T removing H', ...
                  'Part. corr. S mean imput. and H removing T', ...
                  'Part. corr. H and T removing S mean imput.', ...
                  'Part. corr. S list-wise del. and T removing H', ...
                  'Part. corr. S list-wise del. and H removing T', ...
                  'Part. corr. H and T removing S list-wise del.', ...
                  'Part. corr. S linear reg. and T removing H', ...
                  'Part. corr. S linear reg. and H removing T', ...
                  'Part. corr. H and T removing S linear reg.'};
end