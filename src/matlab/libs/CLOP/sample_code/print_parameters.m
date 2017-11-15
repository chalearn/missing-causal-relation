function print_parameters(p, filename)
%print_parameters(p, filename)
% Print dataset parameters and statistics

% Isabelle Guyon -- August 2003 -- isabelle@clopinet.com

if nargin<2, 
    fp=1; 
else
    fp=fopen(filename, 'w');
end

fprintf(fp, 'Number of features: %d\n', p.feat_num);
fprintf(fp, 'Number of examples and check-sums:\n');
fprintf(fp, '     \tPos_ex\tNeg_ex\tTot_ex\tCheck_sum\n');
fprintf(fp, 'Train\t%5d\t%5d\t%5d\t', ...
    p.train_pos_num, p.train_num-p.train_pos_num, p.train_num);
if isfield(p, 'train_check_sum')
    fprintf(fp, '%5.2f\n', p.train_check_sum);
else
    fprintf(fp, '\n');
end
fprintf(fp, 'Valid\t%5d\t%5d\t%5d\t', ...
    p.valid_pos_num, p.valid_num-p.valid_pos_num, p.valid_num);
if isfield(p, 'valid_check_sum')
    fprintf(fp, '%5.2f\n', p.valid_check_sum);
else
    fprintf(fp, '\n');
end
fprintf(fp, 'Test\t%5d\t%5d\t%5d\t', ...
    p.test_pos_num, p.test_num-p.test_pos_num, p.test_num);
if isfield(p, 'test_check_sum')
    fprintf(fp, '%5.2f\n', p.test_check_sum);
else
    fprintf(fp, '\n');
end
fprintf(fp, 'All  \t%5d\t%5d\t%5d\t', ...
    p.train_pos_num+p.valid_pos_num+p.test_pos_num, ...
    p.train_num-p.train_pos_num+p.valid_num-p.valid_pos_num+p.test_num-p.test_pos_num, ...
    p.train_num+p.valid_num+p.test_num);
if isfield(p, 'train_check_sum')
    fprintf(fp, '%5.2f\n', p.train_check_sum+p.valid_check_sum+p.test_check_sum);
else
    fprintf(fp, '\n');
end 
if nargin>1,
    fclose(fp);
end