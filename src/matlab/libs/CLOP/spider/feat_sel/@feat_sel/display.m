function [str,it]=display(a,tabul,it)

 global display_tree_depth;
  if isempty(display_tree_depth) 
      display_tree_depth=100; 
  end;
  global display_tree_tab_step;
  if isempty(display_tree_tab_step) 
      display_tree_tab_step=3; 
  end;
  global display_tree_show_brackets;
  if isempty(display_tree_show_brackets) 
      display_tree_show_brackets=1; 
  end;


% ----- tabulation stuff ----------
tabulStep=display_tree_tab_step;
printPerm=0;  
if nargin==1  
    tabul=0; 
    printPerm=1; 
    it=[]; 
end;  
  
if ~a.store_all %% simple output
   [str,it]=display_simple(a,tabul,it);
else  
  [str,it]=display(a.algorithm,tabul,it);
  if  display_tree_show_brackets 
    str=[str ones(1,tabul+min(2,tabulStep))*32 '{\n' ];  
  end
  tabul=tabul+tabulStep;  
  lenOfIt=length(it); 
  currIt=it{lenOfIt}; 
  currIt=[currIt 1]; 
  it{lenOfIt}=currIt; %% add 1 to last row 
  [st,it]=display(a.child{1},tabul,it); 
  if length(it{length(it)})<display_tree_depth
    str =[str ones(1,tabul)*32 st];       
  end
  if  display_tree_show_brackets
    if  length(it{length(it)})>=display_tree_depth
      str=[str ones(1,tabul)*32 '...\n'];      
    end
    str =[str ones(1,tabul-tabulStep+min(2,tabulStep))*32 '}\n' ];
  end
  tabul=tabul-tabulStep;  
  
  %% pop index of last item
  lenOfIt=length(it); 
  currIt=it{length(it)};
  currIt=currIt(1:length(currIt)-1); 
  it{lenOfIt}=currIt; 
end
if printPerm
  str=str(1:length(str)-2); % remove last carriage return
  it=deal(it(1:length(it)-1)); % remove last index to tree
  disp(sprintf(char(str)));
end
