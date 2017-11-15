function status=matrix_data_write(filename, X, data_type, log)
%status=matrix_data_write(filename, X, data_type, log)
% Write matrix X in the ASCII format of the benchmark. 
% The sparse matrix format for binary data consists of lines of 
% indices of non-zero elements.
% The sparse matrix format for integer data onsists of lines of 
% indices of non-zero elements followed by a colon followed by the
% values. 
% The non-sparse matrix format is just a regular table.
% The delimeters expected are spaces between values and new lines
% between lines.
% Inputs:
% filename -- Name of the file to write to.
% X -- Matrix to write.
% data_type -- Type of data: non-sparse, sparse-integer, or sparse-binary.
% log -- log file descriptor.
% Returns:
% status -- 1 if write OK, 0 otherwise.

% Isabelle Guyon -- November 2004 -- isabelle@clopinet.com

if nargin<3 || isempty(data_type), data_type='non-sparse'; end
if nargin<4, log=2; end
if log >0
    fprintf(log, 'Saving to file %s ...\n', filename);
end

% Save file
fp=fopen(filename, 'w');
[p,n]=size(X);
percent_done=0;
old_percent_done=0;
issp=issparse(X);
block_num=50;
block_size=ceil(p/block_num);
beg=1;
fin=block_size;
i=1;
for k=1:block_num
    rng=beg:fin;
    if issp
        Xb=full(X(rng,:));
    else
        Xb=X(rng,:);
    end
    for j=1:size(Xb, 1)
        if log >0
            percent_done=floor(i/p*100);
            if ~mod(percent_done,10) & percent_done~=old_percent_done,
                fprintf(log, '%d%% ', percent_done);
            end
            old_percent_done=percent_done;
        end
        switch data_type
            case 'non-sparse'
                fprintf(fp, '%d ', Xb(j,:));
            case {'sparse', 'sparse-integer'}
                idx=find(X(i,:)~=0);
                val=X(i,idx);
                mm=full([idx;val]);
                fprintf(fp, '%d:%d ', mm(:));
            case 'sparse-binary'
                idx=find(X(i,:)~=0); % Binarizes automatically
                fprintf(fp, '%d ', idx);
            otherwise error('Wrong type');
        end
        fprintf(fp, '\n');
        i=i+1;
    end
    beg=fin+1;
    fin=min(fin+block_size, p);   
end
fclose(fp);
