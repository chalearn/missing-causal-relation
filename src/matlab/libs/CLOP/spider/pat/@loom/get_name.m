function s=get_name(a)

s=[get_name(a.algorithm)];  %% print name of algorithm
eval_name                   %% print values of hyperparameters
s=[s ' A=' num2str(a.A) ' R=' num2str(a.R)];
