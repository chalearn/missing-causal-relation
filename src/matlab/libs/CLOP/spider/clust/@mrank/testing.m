function [dat, algo]  =  testing(algo,dat)

points = get_x(dat);
labels = get_y(dat);
remove_query_points_from_result = 0;

% If labels are supplied in dat, throw away the data stored in algo and do
% a query using dat. Otherwise use any unlabelled stored points as the
% unlabelled points, and the points from dat as labelled points.

if isempty(labels)
	stored_points = get_x(algo.dat);
	stored_labels = get_y(algo.dat);
	if isempty(stored_labels), stored_labels = zeros(size(stored_points, 1), 1); end
	stored_points(stored_labels ~= 0, :) = []; % remove previous query points if any
	labels = [zeros(size(stored_points, 1), 1); ones(size(points, 1), 1)];
	points = [stored_points; points];
	remove_query_points_from_result = 1;
end
[dat, algo] = training(algo, data(points, labels));
dat = set_name(dat, [get_name(dat) ' -> ' get_name(algo)]);
dat = set_y(dat, algo.result(:, 2));