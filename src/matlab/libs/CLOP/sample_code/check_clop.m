function check_clop

dataset     = {'ada', 'gina', 'hiva', 'nova', 'sylva'}; 
modelset    = model_examples2;

for i=1:length(modelset)
    for j=1:length(dataset)
        my_model=model_examples2(modelset{i}, dataset{j});
        if ~isclop(my_model)
            error('booh');
        end
    end
end
