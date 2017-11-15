function [dat, algo]  =  training(algo,dat)
kernelType = lower(algo.child.ker);

if isempty(algo.standardize)
    if ~isempty(findstr([kernelType '      '], 'linear')) | ~isempty(findstr([kernelType '    '], 'poly'))
        algo.standardize = 0;
    else
        algo.standardize = 1;
    end
    if algo.algorithm.verbosity > 0, disp(['setting standardization option to ' num2str(algo.standardize)]), end
end
X = get_x(dat);
labels = get_y(dat);
if isempty(labels), labels = zeros(size(X, 1), 1); end
labelled = (labels ~= 0);

if ~isempty(findstr([kernelType '   '], 'rbf')) & isempty(algo.child.kerparam)
     algo.child.kerparam = 0.05 * size(X, 2);
     if algo.algorithm.verbosity > 0, disp(['setting RBF sigma to ' num2str(algo.child.kerparam)]), end
end
algo.dat = dat;
if ~any(labelled), return, end
[m, d] = size(X);
if algo.standardize, [X, mu, sd] = centre_and_standardize(X); end
if algo.normalize, X = X ./ repmat(sqrt(sum(X.^2, 2)), 1, d); end
if strcmp(kernelType, 'rbf')
    [K, sed] = rbf_kernel(X, algo.child.kerparam);
    if algo.use_edge_graph
        [algo.mst max_squared_edge_length] = minimum_spanning_tree(sed);
        algo.edge_graph = (sed <= max_squared_edge_length);
        K(~algo.edge_graph) = 0;
        algo.edge_graph = sparse(algo.edge_graph);
    end
    clear sed
else
    if algo.use_edge_graph
        warning('edge graph is only implemented for use with the RBF kernel')
    end
    K = calc(algo.child, data(X));
end

K(1:m+1:end) = 0;
K = sparse(K);
D = diag(1./sqrt(sum(K, 2)));
K = D * K * D; % each element is divided by (the sqrt of the sum of its column * the sqrt of the sum of its row)
y = sum(K(:, labelled), 2);
K = algo.alpha * K(:, ~labelled);
for iteration = 2:algo.iterations
  y(:, iteration) = y(:, 1) + K * y(~labelled, iteration-1);
end
y(labelled, :) = nan;
r = y; r(~labelled, :) = compute_ranks(-r(~labelled, :));
algo.convergence = (r - repmat(r(:, end), 1, algo.iterations))/(m-sum(labelled));
algo.result = [[1:m]' y(:, end) r(:, end)];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [X, mu, sd] = centre_and_standardize(X)
mu = mean(X, 1);
sd = std(X, 0, 1);
X = X -  repmat(mu, size(X, 1), 1);
X = X ./ repmat(sd, size(X, 1), 1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function sed = squared_euclidean_distances(X)
  
[n, d] = size(X);
sed = zeros(n);
for col=1:d
  kc = repmat(X(:, col), 1, n);
  kc = kc - kc.';
  sed = sed + kc.^2;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [K, sed] = rbf_kernel(X, sigma)

sed = squared_euclidean_distances(X);
K = sed/(-2*sigma.^2);
K = exp(K);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [E, max_sed_in_tree] = minimum_spanning_tree(sed)

max_sed_in_tree = 0;
E = zeros(size(sed));
n = size(E, 1);
C = logical(zeros(n, 1));

cmp = sed;
cmp(1:n+1:end) = nan;
[ans i] = min(cmp(:)); 
[i j] = ind2sub([n n], i);
for nC = 1:n
  cmp = sed;
  cmp(C, :) = nan;
  cmp(:, ~C) = nan;
  [ans i] = min(cmp(:)); 
  [i j] = ind2sub([n n], i);
  E(i, j) = nC;
  E(j, i) = nC;
  C(i) = 1;
  max_sed_in_tree = max(max_sed_in_tree, sed(i, j));
end
E = sparse(E);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function rm = compute_ranks(am)

rm = zeros(size(am));
for j = 1:size(am, 2)
    a = am(:, j);
    [sorted r] = sort(a);
    r(r) = 1:length(r);
    while 1
        tied = sorted(min(find(diff(sorted) == 0)));
        if isempty(tied), break, end
        sorted(sorted==tied) = nan;
        r(a==tied) = mean(r(a==tied));
    end
    rm(:, j) = r;
end
