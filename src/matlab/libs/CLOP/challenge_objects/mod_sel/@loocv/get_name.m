function s=get_name(a)
 
global display_tree_show_defaults; 
if isempty(display_tree_show_defaults) 
    display_tree_show_defaults=0; 
end;

show=display_tree_show_defaults; 
s=[get_name(a.algorithm)];

eval_name
