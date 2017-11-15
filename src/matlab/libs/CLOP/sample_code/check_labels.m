function check_labels(Y, pat_num, pos_num)
%check_labels(Y, pat_num, pos_num)
% Function that checks the sanity of the labels.

% Isabelle Guyon -- August 2003 -- isabelle@clopinet.com
% ---------
% Modified by: Amir Reza Saffari Azar, amir@ymer.org, Sep. 22
% ---------

%% AMIR BEGINS %%
if isempty(Y)
    
    disp('Warning: Labels are not available for this set !!!')
    
else
    
    if length(Y)~=pat_num, error('Wrong number of examples'); end
    if length(find(Y>0))~=pos_num, error('Wrong number of positive examples'); end
    if length(find(Y<0))~=pat_num-pos_num, error('Wrong number of negative examples'); end

end

return
%% AMIR ENDS %%