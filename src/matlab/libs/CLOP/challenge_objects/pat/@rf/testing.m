function dat  =  testing(algo,dat)
%dat =  testing(algo,dat)
% Test a Random Forest classifier.
% Inputs:
% algo -- A rf classifier object.
% dat -- A test data object.
% Returns:
% dat -- The same data structure, but X is replaced by the class label
% predictions on test data.

% Isabelle Guyon -- September 2005 -- isabelle@clopinet.com

forest=algo.forest;
targets=algo.targets;

X_te=full(get_x(dat)); % Sparse matrices not supported
[p,n] = size(X_te);
Y_te=rand(p,1);
Y_resu=-ones(p,1);
Y_conf=ones(p,1);

if ~isempty(forest)
    switch algo.optimizer
        case 'R'
            preds=fevalR('RFtest', 'forest', forest, 'xtest', X_te);
            % warning, may have inverted the 2 classes.
            % case of 2 classes only
            outval=preds.resu(:,2)-preds.resu(:,1);
            Y_conf=abs(outval);
            Y_resu=sign(outval);
            zero_val=find(Y_resu==0); % remove ties
            Y_resu(zero_val)=algo.algorithm.default_output;

        case 'Weka'
            % ...
                case 'Merk'
            param = forest.param;
            warning off
            out = RFClass(param, X_te, Y_te, forest);
            warning on

            Y_resu=targets(out.ypredts);
            zero_val=find(Y_resu==0); % remove ties
            Y_resu(zero_val)=algo.algorithm.default_output;

            Y_conf=abs(log(out.countts(:,2)+1)-log(out.countts(:,1)+1));
            zero_val=find(Y_conf==0); % remove ties
            Y_conf(zero_val)=eps;

            %Y_resu=out.countts(:,2)-out.countts(:,1);
            % we use the counts as class likelihoods
            % the discriminant value is log(p1/p2)
    end
end

if algo.algorithm.use_signed_output
    dat=set_x(dat, Y_resu);
else
    %dat=set_x(dat, Y_resu);
    dat=set_x(dat,Y_resu.*Y_conf); 
end
 
dat=set_name(dat,[get_name(dat) ' -> ' get_name(algo)]); 
  

 