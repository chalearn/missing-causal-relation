function Data=create_data_struct(filename, do_not_load_test_data)
%Data=create_data_struct(filename, do_not_load_test_data)
% Input:
% filename -- Trunk name of the Data files (including directory path), with
%               no extension.
% do_not_load_test_data -- 0/1 flag instructing not to load the test data
% Returns:
% Data     -- A structure with 3 fields 'train', 'valid', and 'test'
%               containing Data objects in the spider format.

% Isabelle Guyon -- isabelle@clopinet.com -- September 2005
%
% ---------
% Modified by: Amir Reza Saffari Azar, amir@ymer.org, Sep. 22
% ---------

if nargin<2, do_not_load_test_data=0; end
    
p   = read_parameters(filename);
print_parameters(p);

if fcheck([filename '.mat'])
    % Reload an existing structure
    warning off
    Data = load(filename); 
    Data = Data.Data;
    warning on
    % Recreate a data object (potential conflict with sample code)
    set_name    = fieldnames(Data);
    for j = 1:length(set_name)
       	X = Data.(set_name{j}).X;
        Y = Data.(set_name{j}).Y;
        Data.(set_name{j}) = data(X, Y);
    end
    if do_not_load_test_data
        if isfield(Data, 'test'),
            Data=rmfield(Data, 'test');
        end
        return
    elseif isfield(Data, 'test')
        return
    end
end

if do_not_load_test_data
    Data        = struct('train',[],'valid',[]);
else
    Data        = struct('train',[],'valid',[],'test',[]);
end
set_name    = fieldnames(Data);

% Read the Data
for j = 1:length(set_name)
    Y = read_labels([filename '_' set_name{j} '.labels']);
    dataname=[filename '_' set_name{j}];
    if exist([dataname '.data']) == 2,
        X = matrix_data_read([dataname '.data'], ...
            p.feat_num, ...
            p.([set_name{j} '_num']), ...
            p.data_type);
    elseif exist([dataname '.csv']) == 2,
        X = textread([dataname '.csv'], '%s', 'delimiter', ',');
        X = reshape(X,length(X)/p.([set_name{j} '_num']),p.([set_name{j} '_num']))';
    end
    Data.(set_name{j}) = data(X , Y);
end

% Save in Matlab format
save(filename, 'Data');

% Check the Data
for j = 1:length(set_name) 
    check_labels(Data.(set_name{j}).Y, ...
                 p.([set_name{j} '_num']), ...
                 p.([set_name{j} '_pos_num']));
end

if isfield(p, 'train_check_sum')
    for j = 1:length(set_name) 
        check_data(Data.(set_name{j}).X, p.([set_name{j} '_num']), ...
                   p.feat_num, ...
                   p.([set_name{j} '_check_sum']));
    end
end

return