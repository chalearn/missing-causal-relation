function dout = testing(a0,d)

testpoints=get_x(d)';

[sample_dim nr_of_samples]=size(testpoints); % V contains your data in its column vectors
r=a0.N; % choose your own rank for the factorization

maxiter=a0.maxIteration;		% choose the maximum number of iterations
H=abs(randn(r,nr_of_samples));	% randomly initialize basis
H=H./(ones(r,1)*sum(H)); % normalize column sums

objective=Inf;

% TODO: maybe do a convergence check here.
for iter=1:maxiter
	disp(['Iter ', num2str(iter), ', objective function: ', num2str(objective)]);

	% testpoints \approx a0.W*H
	H = H .* (a0.W'*testpoints) ./ (a0.W'*a0.W*H + 1e-9);

	% Normalization is not necessary
	objective = 0.5*sum(sum((testpoints-a0.W*H).^2));
end

dout=d;
dout.X=H';

