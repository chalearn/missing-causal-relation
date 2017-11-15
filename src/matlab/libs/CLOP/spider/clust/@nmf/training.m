function [dout,alg] = training(a0,d)

if a0.algorithm.verbosity>0
	disp(['training ' get_name(a0) '.... '])
end

nr_of_samples=size(d.X,1);
dim_of_samples=size(d.X,2);

V=get_x(d)';
size(V)

alg=a0;
dout=data([],d.X);

r=nr_of_samples;
eps=a0.eps;

if(isempty(a0.N))
	a0.N=dim_of_samples;
end

foundmodels=[];

bestobjective = Inf;
bestW = [];
bestH = [];
for seeking_model=1:a0.nrofrestarts
	foundmodels=[foundmodels;alg];

	% Code based on Patrik Hoyer's code
	W=abs(randn(dim_of_samples,a0.N));
	H=abs(randn(a0.N,nr_of_samples));

	lastobjective = Inf;
	objective = 0.5*sum(sum((V-W*H).^2));	% MSE

	iteration=0;

	conv = Inf;
	while conv > eps & iteration < a0.maxIteration
		iteration=iteration+1;
		fprintf('%d  obj: %f   conv: %f\n',[iteration, objective, conv])

		% From Patrik Hoyer's code
		H = H.*(W'*V)./(W'*W*H + 1e-9);
		W = W.*(V*H')./(W*H*H' + 1e-9);

		% Renormalize so rows of H have constant energy
		norms = sqrt(sum(H'.^2));
		H = H./(norms'*ones(1,nr_of_samples));
		W = W.*(ones(dim_of_samples,1)*norms);

		% Calculate objective
		lastobjective = objective;
		objective = 0.5*sum(sum((V-W*H).^2));
		conv = lastobjective - objective;
	end

	if objective < bestobjective
		bestW = W;
		bestH = H;
		bestobjective = objective;
	end
end

alg.W = bestW;
alg.H = bestH;

%dout.X=(alg.W*alg.H)';
dout.X=alg.H';	% The reduced features

display(['NMF Reconstruction Error: ' sprintf('%f',bestobjective)]);


