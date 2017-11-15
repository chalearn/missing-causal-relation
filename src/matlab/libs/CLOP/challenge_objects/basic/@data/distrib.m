function distrib(D)
%distrib(D)
% Show the data distribution

xs=get_x(D);
xs=sort(xs(:));
figure; plot(xs, 1:length(xs)); xlabel('rank'); ylabel('value');


end

