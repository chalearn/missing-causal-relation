function my_model = model_examples(model_name, data_name)
%my_model = model_examples(model_name, data_name)
% Generate a number of examples of models, to test a variety of combinations.
% Use [> type model_examples] to view the code.
% Use [> model_examples] to view the choice of model names
% Input:
% model_name -- The name of the model chosen.
% data_name -- The name of the dataset on which the model will be used.
%              This last input is rendered necessary so that all examples
%              work on all datasets because some combinations of
%              preprocessings or hyperparameters are computationally
%              infeasible or use too much memory resources.
% Output:
% my_model -- A chain of algorithm including a svc, ridge, naive, rf, a
%             neural object

% Isabelle Guyon -- September 2006 -- isabelle@clopinet.com

basic_models={'zarbi', 'kridge', 'naive', 'neural', 'rf', 'svc', 'gentleboost', 'lssvm'};
basic_prepro={'s2n', 'gs', 'relief', 'rffs', 'svcrfe', ...
            'standardize', 'normalize', 'shift_n_scale', ...
            'pc_extract', 'subsample'};

if nargin<1 | isempty(model_name)
        my_model= ...
              {
              'zarbi'
              'Prepro+naiveBayes'
              'Prepro+linearSVC'
              'PCA+kernelRidge'
              'Prepro+nonlinearSVC'
              'GS+kernelRidge'
              'S2N+RFFS+RF'
              'Relief+neuralNet'
              'RFE+SVC'
              'naiveBayes_Ensemble'
              'linearSVC_Ensemble'
              'Boosting'
              'RF'
              };
    return;
end

switch model_name
    case basic_models
        % These are the raw models. They do not necessarily work on all
        % datasets and may need preprocessing.
        my_model=eval(model_name);
    case basic_prepro
        % These are the the feature extraction and preprocessing functions
        % coupled with naive Bayes. This deso not necessarily work on all
        % datasets and may need hyperpameter tuning.
        my_model=chain({eval(model_name), naive})
    case 'Prepro+linearSVC'
        % Support vector classifier 
        % with linear kernel (the default.)
        if strcmp(data_name, 'nova')
            my_model=svc('shrinkage=0.1') % Standardizing nova poses memory problems
        else
            my_model=chain({standardize, svc('shrinkage=0.1')})
        end
    case 'Prepro+naiveBayes'
        % A complex chain of preprocessing followed by a Naive Bayes
        % classifier.
        my_prepro={standardize, s2n('f_max=200'), shift_n_scale('take_log=1'), normalize};
        if strcmp(data_name, 'hiva') | strcmp(data_name, 'nova')
            my_model=naive % The preprocessing is inadequate for hiva and nova
        else
            my_model=chain({my_prepro{:}, naive})
        end
    case 'PCA+kernelRidge'
        % Preprocessing with standardization,
        % followed by the extraction of the first 100 principal
        % components and by kernel ridge regression.
        my_classif={standardize, pc_extract('f_max=100'), kridge};
        if strcmp(data_name, 'nova')
            my_model=kridge % pca is long to perform on Nova
        elseif  strcmp(data_name, 'hiva') 
            % balancing the training set helps pca for Hiva
            my_model=chain({subsample({'p_max=200', 'balance=1'}), my_classif{:}})
        else
            my_model=chain(my_classif)
        end
    case 'Prepro+nonlinearSVC'
        % Preprocessing with standardization,
        % support vector classifier with kernel 
        % k(x,y) = (x.y+coef0)^degree * exp(-gamma |x-y|^2)
        my_svc=svc({'coef0=1', 'degree=1', 'gamma=0.001', 'shrinkage=0.1'});
        if strcmp(data_name, 'nova')
            my_model=my_svc % Standardizing nova poses memory problems
        elseif strcmp(data_name, 'sylva')
            % Sylva is very big for nonlinearSVC (takes long to train)
            my_model=chain({subsample('p_max=3000'), standardize, my_svc})
        else
            my_model=chain({standardize, my_svc})
        end
    case 'GS+kernelRidge'
        % Feature standardization followed by,
        % Gram-Schmidt feature selection (down to 10 features),
        % and by a ridge regression with kernel 
        % k(x,y) = (x.y+coef0)^degree * exp(-gamma |x-y|^2)
        % The example is a linear ridge regression (the default.)
        my_classif=kridge({'shrinkage=0.01', 'balance=1'});
        if strcmp(data_name, 'nova')
            my_model=my_classif
        else
            % This does not work for large sparse matrices like Nova:
            my_model=chain({standardize, gs('f_max=10'), my_classif})
        end
    case 'S2N+RFFS+RF'
        % Feature selection with S2N (reduce only to 200 features)
        % further reduction to 10 features with Random Forest feature
        % selection, followed by Random Forest classification.
        %%%% Note: The present interface to RF is pleagued with several
        %%%% bugs: segmentation faults occur for large datasets
        %%%% data balancing and the use of categorical variables
        %%%% does not work yet.
        my_classif={s2n('f_max=200'), rffs('f_max=10'), rf({'units=100', 'mtry=6'})};
        if strcmp(data_name, 'sylva')
            my_model=chain({subsample('p_max=3000'), my_classif{:}})
        elseif strcmp(data_name, 'hiva') | strcmp(data_name, 'nova') 
            my_model=naive; % We did not get RF to work on categorical variables so far
        else
            my_model=chain(my_classif)
        end
    case 'RF'
        switch data_name
            case 'gina'
                my_model=rf({'units=100', 'balance=0'});
            case 'hiva'
                my_model=chain({rf({'units=100', 'balance=0'}), bias});
            case 'nova' 
                my_model=chain({rmconst, rf({'units=100', 'balance=1'}) , bias});
           otherwise
                my_model=chain({rf({'units=100', 'balance=1'}), bias});
        end
    case 'Boosting'
        switch data_name
            case 'ada'
                base_model  = neural({'units=1', 'shrinkage=0.1' , 'balance=1' , 'maxiter=300'});
                my_model  = chain({shift_n_scale({'take_log=1'}), standardize, normalize, gentleboost(base_model , {'units=5'}) , bias});

            case 'gina'
                base_model  = svc({'coef0=0.1', 'degree=5', 'gamma=0', 'shrinkage=0.01'});
                my_model    = chain({normalize , base_model , bias});

            case 'hiva'
                base_model  = kridge({'shrinkage=1'});
                my_model    = chain({standardize , normalize , gentleboost(base_model , {'units=10'}) , bias});

            case 'nova'
                base_model  = neural({'units=1', 'shrinkage=0.2' , 'balance=1', 'maxiter=50'});
                my_model    = chain({normalize , gentleboost(base_model , {'units=10'}) , bias});

            case 'sylva'
                base_model  = neural({'units=1', 'shrinkage=2' , 'balance=1', 'maxiter=100'});
                my_model    = chain({standardize , normalize , gentleboost(base_model , {'units=5'}) , bias});
        end
    case 'Relief+neuralNet'
        % Feature standardization, selection of 40 features
        % by relief, followed by Neural Network classification.
        my_classif=neural({'units=10', 'shrinkage=0.01', 'balance=1', 'maxiter=100'});
        if strcmp(data_name, 'sylva')
            % Sylva is too big for Relief
            my_model=chain({standardize, my_classif})
        elseif strcmp(data_name, 'nova')
            % Standardization in impractical for Nova
            my_model=chain({relief('f_max=40'), my_classif})
        else
            my_model=chain({standardize, relief('f_max=40'), my_classif})
        end
    case 'RFE+SVC'
        % Feature standardization, selection of 40 features
        % by RFE SVC, followed by a linear SVC.
        my_classif={svcrfe({svc('shrinkage=0.1'), 'f_max=40'}), svc('shrinkage=0.1')};
        if strcmp(data_name, 'nova')
            % Standardization in impractical for Nova
            my_model=chain(my_classif)
        else
            my_model=chain({standardize, my_classif{:}})
        end
    case 'linearSVC_Ensemble'
        % Ensemble of support vector classifiers 
        % having several different hyperparameters.
        for k=1:3
            if strcmp(data_name, 'nova')
                base_model{k}=svc(['shrinkage=' num2str(10^-(k-1))]); % Standardizing nova poses memory problems
            else
                base_model{k}=chain({standardize, svc(['shrinkage=' num2str(10^-(k-1))]) });
            end
        end
        my_model=ensemble(base_model, 'signed_output=1')
    case 'naiveBayes_Ensemble'
        % Ensemble of Naive Bayes classifiers 
        % build from data subsamples (bagging ensemble).
        for k=1:10
            if strcmp(data_name, 'nova')
                base_model{k}=chain({subsample({'p_max=1500', 'balance=1'}), naive}); ; % Standardizing nova poses memory problems
            else
                base_model{k}=chain({subsample({'p_max=3000', 'balance=1'}), standardize, naive});
            end
        end
        my_model=ensemble(base_model, 'signed_output=1')
    case 'ada'
        my_model=chain({ada_prepro, standardize, zarbi});
    case 'gina'
        my_model=rf({'units=100', 'balance=0'});
        %my_classif=svc({'coef0=0.1', 'degree=5', 'gamma=0', 'shrinkage=0.01'});
        %my_model=chain({convolve(exp_ker({'dim1=9', 'dim2=9'})), normalize, my_classif});
    case 'sylva'
        my_model=chain({rf({'units=100', 'balance=1'}), bias});
    case 'pixelGina_exp_conv'
        %if ~UsePixelRep, 
        %    error('Does not work if the representation is not pixels');
        %end
        % Purposely designed for Gisette, smoothe pixels
        my_classif=svc({'coef0=1', 'degree=4', 'gamma=0', 'shrinkage=0.1'});
        my_model=chain({convolve(exp_ker({'dim1=9', 'dim2=9'})), normalize, my_classif})
        %my_model=chain({subsample('p_max=200'), normalize, my_classif});
    case 'pixelGina_gauss_conv'
        %if ~UsePixelRep, 
        %    error('Does not work if the representation is not pixels');
        %end
        % Purposely designed for Gisette, smoothe pixels
        %my_classif=svc({'coef0=1', 'degree=4', 'gamma=0', 'shrinkage=0.5'});
        my_classif=svc({'coef0=1', 'degree=5', 'gamma=0', 'shrinkage=0.01'});
        my_model=chain({convolve(gauss_ker({'dim1=5', 'dim2=5'})), normalize, my_classif});
    case 'hiva'
        my_model=chain({rmconst, naive});
	case 'KRIDGE'
        % To go fast, I chained all the objects with subsample, which
        % selects on 200 examples to train.
        switch data_name
            case 'ada'
                my_model  = chain({subsample({'p_max=200', 'balance=1'}), shift_n_scale({'take_log=1'}), standardize, normalize, kridge({'gamma=10', 'degree=0', 'shrinkage=[]'}), bias});
            case 'gina'
                my_model=chain({subsample({'p_max=200', 'balance=1'}), s2n('f_max=485'), normalize, kridge({'balance=0', 'coef0=1', 'degree=5', 'gamma=0', 'shrinkage=[]'}), bias});

            case 'hiva'
                my_model=chain({subsample({'p_max=200', 'balance=1'}), standardize, normalize, kridge({'balance=1', 'coef0=1', 'degree=2', 'gamma=0', 'shrinkage=[]'}), bias});

            case 'nova'
                my_model=chain({subsample({'p_max=200', 'balance=1'}), rmconst, normalize, kridge({'balance=1', 'shrinkage=[]'}), bias});

            case 'sylva'
                my_model=chain({subsample({'p_max=200', 'balance=1'}), kridge({'balance=1', 'shrinkage=[]'}), bias});
	end
    case 'LSSVM'
        % To go fast, I chained all the objects with subsample, which
        % selects on 200 examples to train.
        switch data_name
            case 'ada'
                my_model  = chain({subsample({'p_max=200', 'balance=1'}), shift_n_scale({'take_log=1'}), standardize, normalize, lssvm({'gamma=[]', 'degree=0', 'shrinkage=[]'}), bias});
            case 'gina'
                my_model=chain({subsample({'p_max=200', 'balance=1'}), s2n('f_max=485'), normalize, lssvm({'balance=0', 'coef0=[]', 'degree=5', 'gamma=0', 'shrinkage=[]'}), bias});

            case 'hiva'
                my_model=chain({subsample({'p_max=200', 'balance=1'}), standardize, normalize, lssvm({'balance=1', 'coef0=1', 'degree=2', 'gamma=0', 'shrinkage=[]'}), bias});

            case 'nova'
                my_model=chain({subsample({'p_max=200', 'balance=1'}), rmconst, normalize, lssvm({'balance=1', 'shrinkage=[]'}), bias});

            case 'sylva'
                my_model=chain({subsample({'p_max=200', 'balance=1'}), lssvm({'balance=1', 'shrinkage=[]'}), bias});
        end
  case 'KLR'
        % To go fast, I chained all the objects with subsample, which
        % selects on 200 examples to train.
        switch data_name
            case 'ada'
                my_model  = chain({subsample({'p_max=200', 'balance=1'}), shift_n_scale({'take_log=1'}), standardize, normalize, klogistic('option=2'), bias});
            case 'gina'
                my_model=chain({subsample({'p_max=200', 'balance=1'}), s2n('f_max=485'), normalize, klogistic('option=2'),  bias});

            case 'hiva'
                my_model=chain({subsample({'p_max=200', 'balance=1'}), standardize, normalize, klogistic('option=2'),  bias});

            case 'nova'
                my_model=chain({subsample({'p_max=200', 'balance=1'}), rmconst, normalize, klogistic('option=2'),  bias});

            case 'sylva'
                my_model=chain({subsample({'p_max=200', 'balance=1'}), rmconst, standardize, klogistic('option=2'),  bias});
        end
 case 'KRR'
        % To go fast, I chained all the objects with subsample, which
        % selects on 200 examples to train.
        switch data_name
            case 'ada'
                my_model  = chain({subsample({'p_max=200', 'balance=1'}), shift_n_scale({'take_log=1'}), standardize, normalize, gkridge, bias});
            case 'gina'
                my_model=chain({subsample({'p_max=200', 'balance=1'}), s2n('f_max=485'), normalize, gkridge, bias});

            case 'hiva'
                my_model=chain({subsample({'p_max=200', 'balance=1'}), standardize, normalize, gkridge, bias});

            case 'nova'
                my_model=chain({subsample({'p_max=200', 'balance=1'}), rmconst, normalize, gkridge, bias});

            case 'sylva'
                my_model=chain({subsample({'p_max=200', 'balance=1'}), gkridge, bias});
        end
    case 'LB' % Logitboost
         switch data_name
            case {'hiva', 'nova'}
                my_model=chain({rmconst, s2n('f_max=200'), logitboost, bias});
             otherwise
                my_model=chain({rmconst, logitboost, bias});
         end
    otherwise
        error('No such model!');
end