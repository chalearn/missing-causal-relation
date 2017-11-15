function my_model=load_model(filename)
% my_model=load_model(filename)
% Reload a model stored under any name in filename 
% as a Matlab object (with the save command).

% Isabelle Guyon -- October 2005 -- isabelle@xlopinet.com

mm  = load(filename);
ff  = fieldnames(mm);
my_model =  mm.(ff{1});

%if ~isclop(my_model)
%    error('This is not a valid CLOP model');
%end