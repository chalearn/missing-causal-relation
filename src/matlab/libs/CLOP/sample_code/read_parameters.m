function p=read_parameters(filename)
%p=read_parameters(filename)
% Read dataset parameters and statistics

% Isabelle Guyon -- August 2003 -- isabelle@clopinet.com

if isempty(strfind(filename, '.param'))
    filename=[filename '.param'];
end
fp=fopen(filename, 'r');

p.data_type=fscanf(fp, 'Data type: %s\n');
p.feat_num=fscanf(fp, 'Number of features: %d\n');
fgetl(fp);
fgetl(fp);
m=fscanf(fp, 'Train\t%d\t%d\t%d\t%g\n');
if length(m)>3, cs=1; else cs=0; end
p.train_pos_num=m(1);
p.train_neg_num=m(2);
p.train_num=m(3);
if cs, p.train_check_sum=m(4); end
m=fscanf(fp, 'Valid\t%d\t%d\t%d\t%g\n');
p.valid_pos_num=m(1);
p.valid_neg_num=m(2);
p.valid_num=m(3);
if cs, p.valid_check_sum=m(4); end
m=fscanf(fp, 'Test\t%d\t%d\t%d\t%g\n');
p.test_pos_num=m(1);
p.test_neg_num=m(2);
p.test_num=m(3);
if cs, p.test_check_sum=m(4); end
m=fscanf(fp, 'All\t%d\t%d\t%d\t%g\n');
p.all_pos_num=m(1);
p.all_neg_num=m(2);
p.all_num=m(3);
if cs, p.all_check_sum=m(4); end

fclose(fp);
