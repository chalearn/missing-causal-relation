function plot(algo, whichplots, dims)
% PLOT(M [, WHICHPLOTS] [, DIMS])
% 
% M is an MRANK algorithm that has been trained on a partially labelled
% data set (i.e. one that had some query points with non-zero labels).
% 
% DIMS is a two-element vector specifying which dimensions of the data to
% use in the two-dimensional plots. It defaults to [1 2].
% 
% WHICHPLOTS is a string containing the letters 'E', 'T', 'R' and/or 'C',
% specifying which plots to produce: 'T' for the minimum spanning tree (if
% the option M.use_edge_graph was set), 'E' for the edge graph itself
% (again, only if enabled), 'R' for the ranking results and 'C' for a plot
% of the convergence of the ranks.

if nargin < 2, whichplots = ''; end
if nargin < 3, dims = []; end

if ~isnumeric(dims) | ~ischar(whichplots), [dims whichplots] = deal(whichplots, dims); end

if isempty(whichplots), whichplots = 'r'; end
if isempty(dims), dims = [1 2]; end

if isempty(algo.dat), X = []; else X = get_x(algo.dat); end

whichplots = lower(whichplots);
if isempty(algo.edge_graph) | isempty(X), whichplots(whichplots=='e' | whichplots=='t') = []; end
if isempty(algo.result) | isempty(X), whichplots(whichplots=='r') = []; end
if isempty(algo.convergence), whichplots(whichplots=='c') = []; end
if isempty(whichplots), error('nothing to plot'), end


nplots = length(whichplots);
ncols = round(sqrt(nplots));
nrows = ceil(nplots/ncols);


for i = 1:nplots
    subplot(nrows, ncols, i)
    cla
    set(gca, 'plotboxaspectratio', [1 1 1])
    switch whichplots(i) 
        case 't'
            plotspantree(algo.mst, X(:, dims))
        case 'e'
            plotedgegraph(algo.edge_graph, X(:, dims))
        case 'r'
            plotranking(algo.result, X, dims)
        case 'c'
            plotrankingconvergence(algo.convergence)
            set(gca, 'plotboxaspectratiomode', 'auto')
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plotspantree(E, X)

m = size(X, 1);
cmap = jet(m);
for ind = 1:m
  [i j] = find(E == ind);
  i = i(1); j = j(1);
  line(X([i j], 1), X([i j], 2), 'color', cmap(ind, :))
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plotedgegraph(E, X)

[i j] = find(E);
xx = X(:, 1);
xx = xx([i j]);
yy = X(:, 2);
yy = yy([i j]);
line(xx', yy')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plotrankingconvergence(cvg)

plot(cvg')
xlabel iteration
ylabel 'convergence to final rank'
ylim([-1 1])
