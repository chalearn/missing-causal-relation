
%% used to print out parameters  -- needed for most objects! 
%% IG: This overloads a method of the spider and adds more options.

a=struct(a);
if isfield(a, 'display_fields')
    f=a.display_fields;
else
    f=fieldnames(a);
end

if isfield(a,'child') & ~isempty(a.child)
    if isobject(a.child),
        s=[s ' ' get_name(a.child)]; 
    elseif iscell(a.child)
        if isobject(a.child{1}),
            s=[s ' ' get_name(a.child{1})];
        end
    end   
end
for k=1:length(f)
    membr=a.(f{k});
    if (length(membr)==1) & isnumeric(membr) % Dec 17 IG
        membr=full(membr);
        if isempty(membr)
            membr='';
        elseif isnumeric(membr)
            membr=num2str(membr);
        end
        if ischar(membr)
            s = [s ' ' f{k} '=' membr];
        end
    end
end
