function list=whoisclop
%list=whoisclop
% Returns the list of all CLOP objects

% Isabelle Guyon -- isabelle@clopinet.com -- May 2006

list = {'bias'
'chain'
'ensemble'
'gentleboost'
'gs'
'kridge'
'naive'
'neural'
'normalize'
'pc_extract'
'relief'
'rf'
'rffs'
'shift_n_scale'
'standardize'
'subsample'
'svc'
'svcrfe'
's2n'
}

% Verification
for k=1:length(list)
    if ~isclop(eval(list{k}))
        error([list{k} ' is not a CLOP object']);
    end
end
