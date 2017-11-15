function answer=isclop(my_object, CheckFields)
%answer=isclop(my_object, CheckFields)
% This function returns 0/1 depending on whether
% the object belongs to CLOP or not.
% If CheckFields is equal to 1, then it checks the validity of the fields
% of objects too.

% Isabelle Guyon -- isabelle@clopinet.com -- May 2006
% Modified by Amir Saffari, amir@ymer.org, May 2006

answer = 0;

if nargin < 2
    CheckFields = 0;
end

if isempty(my_object)
    answer = 1; % Handles the case of empty children
    return
end

if ~isobject(my_object)
    return
end

SO = struct(my_object);
if isfield(SO, 'IamCLOP') 
    answer = 1;
end

% Recursively checks for the validity of the children
if isfield(SO, 'child')
    if iscell(my_object.child)
        OA = my_object.child;
        for k = 1:length(OA)
            answer = answer*isclop(OA{k}, CheckFields);
        end
    elseif isobject(my_object.child)
        answer = answer*isclop(my_object.child, CheckFields);
    end
elseif CheckFields      % check for fields
    ObjectClass = class(my_object);
    evalc(['EmptyObject = ' ObjectClass]);
    
    EmptyObjStr = struct(EmptyObject);
    InputObjStr = struct(my_object);
    
    EmptyObjFN  = fieldnames(EmptyObjStr);
    InputObjFN  = fieldnames(InputObjStr);
    
    if length(EmptyObjFN) ~= length(InputObjFN)
        answer = 0;
        return
    else
        for j = 1:length(EmptyObjFN)
            if ~strcmp(EmptyObjFN{j} , InputObjFN{j})
                answer = 0;
            end
        end
    end
end

return