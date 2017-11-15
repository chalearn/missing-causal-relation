function [num_train, errate, ebar, a, b, c]=learning_curve(K, Y_train, Y_test, fit)
%[num_train, errate, ebar, a, b, c]=learning_curve(K, Y_train, Y_test, fit)
% Compute a learning curve from a (n_train, n_test) similarity matrix K
% and the target vectors, for the 3 nearest neighbor method.
% Return the number of training examples,
% the error rate and error bar.
% If fit=1, fits the model errate=exp(a*num_train+b) + c

% Isabelle Guyon -- isabelle@clopinet.com -- June 2004

if nargin<4, fit=0; end

a=0; b=0; c=0;
num_rep=10;
num_neighbor=3;
n_train=length(Y_train);
num_train=[5:5:n_train];
q=size(K,3);
n=length(num_train);
errate=zeros(n,q);
ebar=zeros(n,q);
e=zeros(num_rep,q);
for i=1:n
    %10 times randomly select k training patterns
    nt=num_train(i);
    for j=1:num_rep
        rp=randperm(n_train);
        tridx=rp(1:nt);
        % compute errate
        for k=1:q
            [ks,is]=sort(-K(tridx, :, k)); % training patterns only
            Y_hat=sign(sum(Y_train(tridx(is(1:num_neighbor,:)))))'; % top neighbors
            e(j, k)=mean(Y_hat~=Y_test);
        end
    end
    errate(i,:)=mean(e);
    ebar(i,:)=std(e);
end
ebar=ebar./sqrt(num_rep);
%if q==1, errate=errate'; ebar=ebar'; end

if ~fit
    num_train=[0, num_train]; % Add the error rate at origin (50%)
    errate=[0.5*ones(1,q); errate];
    figure; h=plot(num_train, errate);
    if q==1, hold on; plot(num_train, errate, 'ro'); end
    lg=['legend(h'];
    for k=1:q, lg=[lg ', ''' num2str(k) '''']; end
    lg=[lg ')'];
    eval(lg);
else
    figure; plot(num_train, errate, 'ro');
    xlabel('num\_train');
    ylabel('errate');
    num_train=[eps*ones(1,100), num_train]; % Add the error rate at origin (50%)
    errate=[0.5*ones(1,100), errate];
	% Do a linear fit to the log curve
	b0=errate(length(errate));
	bval=[b0/2:b0/50:b0-b0/50];
	if isempty(bval), bval=0; end
	for k=1:length(bval)
        eval=errate-bval(k);
        eval(eval==0)=eps;
        lerrate=log(eval);
        w=lerrate/[num_train;ones(size(num_train))];
        r(k)=sum((w*[num_train;ones(size(num_train))]-lerrate).^2);
	end
	[rr,kk]=min(r);
	eval=errate-bval(kk);
	eval(eval==0)=eps;
	lerrate=log(eval);
	w=lerrate/[num_train;ones(size(num_train))];
    hold on; plot([num_train], [bval(kk)+exp(w*[num_train;ones(size(num_train))])]);
    title(['Learning curve errate=exp(' num2str(a) '*num\_train+' num2str(b) ')+' num2str(c)]);
    figure; plot(num_train, lerrate, 'ro');
    hold on; plot(num_train, w*[num_train;ones(size(num_train))]);
    a=w(1);
    b=w(2);
    c=bval(kk);
    title(['Learning curve errate=exp(' num2str(a) '*num\_train+' num2str(b) ')+' num2str(c)]);
    xlabel('num\_train');
    ylabel('log(errate)');
end