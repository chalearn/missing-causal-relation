function [cv_error, cv_ebar, auc_val, auc_ebar]=cv_test(dat, from_cov, FoldNum, ridge, test_dat)
% [cv_error, cv_ebar, auc_val, auc_ebar]=cv_test(dat, from_cov, FoldNum, ridge, test_dat)
% Perform a cross-validation test on the data.
% Uses the first column of Y as target.
% FoldNum       --  Number of folds
% ridge         --  Uses a linear ridge regression with ridge "ridge"
% from_cov      --  If from_cov=1, predicts from the covarietes instead of from X.
% test_data     --  If test data exists, then we need to use it instead of doing k-fold
% Returns:
% cv_error      --  The ber for classification problems. The 1-R^2 otherwise.
% cv_ebar       --  The error bar of the error
% auc_val and auc_ebar -- AUC and its error bar (for classification only)

% Isabelle Guyon -- isabelle@clopinet.com -- May-June 2007

if nargin<2 | isempty(from_cov), from_cov=0  ; end
if nargin<3 | isempty(FoldNum), FoldNum=10; end
if nargin<4 | isempty(ridge), ridge=10.^-[-2:6]; end
if nargin<5, test_dat=[]; end

auc_val=[]; auc_ebar=[];

debug=1;

% Find whether the target is binary
if length(unique(dat.Y(:,1)))==2
    binary=1;
else
    binary=0;
end

if binary
	my_model=kridge({'degree=1', 'balance=1'});
    my_model.shrinkage=ridge;
else
    my_model=kridge({'degree=1'});
    my_model.shrinkage=ridge;
    if ~from_cov,
        my_model=chain({shift_n_scale('take_log=1'), standardize, my_model});
    end
end
    
% Format the data
if from_cov
    D=data(dat.Y(:,2:size(dat.Y,2)), dat.Y(:,1));
else
    D=data(dat.X, dat.Y(:,1));
    %D=train(chain({shift_n_scale('take_log=1'), normalize, standardize}), D);
    %D=train(chain({shift_n_scale('take_log=1'), standardize}), D);
end
if ~isempty(test_dat)
    if from_cov
        Dt=data(test_dat.Y(:,2:size(test_dat.Y,2)), test_dat.Y(:,1));
    else
        Dt=data(test_dat.X, test_dat.Y(:,1));
    end
end
    
% performs cv
if isempty(test_dat)
    cv_model    = cv(my_model, {['folds=' num2str(FoldNum)], 'store_all=0'});

    cv_output   = train(cv_model, D); 
    % Collect the results
    OutX = []; OutY = []; ber =[]; ac=[]; r2=[];
    for kk = 1:FoldNum,
        outX    = cv_output.child{kk}.X;
        outY    = cv_output.child{kk}.Y;
        OutX    = [OutX; outX]; 
        OutY    = [OutY; outY]; 
        if binary
            ber(kk) = balanced_errate(outX, outY);
            ac(kk)  = auc(outX, outY);
        else
            mse = mean((outX-outY).^2);
            varY = var(outY, 1);
            r2(kk) = mse/varY;
        end
    end
    if binary
        cv_error   = balanced_errate(OutX, OutY);
        cv_ebar  = std(ber,1)/sqrt(FoldNum);
        auc_val  = auc(OutX, OutY);   
        auc_ebar  = std(ac,1)/sqrt(FoldNum);
    else
        cv_error   = mean((OutX-OutY).^2)/var(OutY, 1);
        cv_ebar  = std(r2,1)/sqrt(FoldNum); 
        if debug, 
            figure; plot(OutY, OutX, '+'); 
            xlabel('Real value'); 
            ylabel('Value predicted'); 
            title(['R^2 = ' num2str(1-cv_error) ' +- ' num2str(cv_ebar)]);
        end
    end
else
    [output_train, my_model]  = train(my_model, D);
    output_test = test(my_model, Dt);
    auc_val=0;
    if binary
        cv_error = balanced_errate(output_test.X, output_test.Y);
        auc_val  = auc(output_test.X, output_test.Y);
    else
        mse = mean((output_test.X-output_test.Y).^2);
        varY = var(output_test.Y, 1);
        cv_error = mse/varY;
    end
end

return


