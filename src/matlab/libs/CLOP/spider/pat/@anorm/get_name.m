function s=get_name(a)

s=[get_name(a.algorithm)];  %% print name of algorithm
eval_name                   %% print values of hyperparameters
s=[s ' norm=' num2str(a.norm)];
