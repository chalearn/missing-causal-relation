function s=get_name(a)
s=[get_name(a.algorithm) ' (' get(a.gkm, 'acronym') ', ' class(a.selector) ')'];  %% print name of algorithm
eval_name                   %% print values of hyperparameters
