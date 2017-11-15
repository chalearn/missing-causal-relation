function s=get_name(a)
s=[get_name(a.algorithm)];  %% print name of algorithm
eval_name                   %% print values of hyperparameters
s=[s ' alpha=' num2str(a.alpha)];
if ~isempty(a.normalize), s = [s ' normalize=' num2str(a.normalize)]; end
if ~isempty(a.standardize), s = [s ' standardize=' num2str(a.standardize)]; end
