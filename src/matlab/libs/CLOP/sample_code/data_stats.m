function data_stats(dat, fp)
% data_stats(dat, fp)
% dat is a data structure
% fp is a file descriptor
% Extract data statistics

% Isabelle Guyon -- isabelle@clopinet.com -- February 2006

if nargin<2, fp=2; end

if ~isnumeric(dat.train.X), return; end

% Collect statistics
fprintf(fp, '\nDataset\tX Type\tSparse\tY Type (c)\tBalance\tFeat\tPat\tPat/Feat\n');
set_name    = fieldnames(dat); % 'train', 'valid' and 'test'
for k=1:length(set_name)
    [vartype, sparsity, tartype, valnum, balance, n, p]=stats(dat.(set_name{k}), -1);
    % Results
    fprintf(fp, '%s\t%s\t%5.3f\t%s (%d)\t%s\t%d\t%d\t%5.3f\n', ...
        set_name{k}, vartype, sparsity, tartype, valnum, balance, n, p, p/n); 
end