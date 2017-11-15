% % % 
% % % Sample script for performing model selection on the CLOP objects using
% % % a particle swarm optimization approach
% % % 
% % % Author:     Hugo Jair Escalante Balderas, Isabelle Guyon and Amir Saffari
% % % Contact:    hugojair@ccc.inaoep.mx
% % %             http://ccc.inaoep.mx/~hugojair
% % % Date:       July 14, 2007
% % % Modif.:     October 31, 2007
% % % 
% % % NOTE: Training psms saves the best models found every iteration in a file named:
% % % psms_bestmodels.mat if Matlab gets stacked or you have no more time for
% % % searching models you may just load that file (load
% % % psms_bestmodels.mat). See lines 84 -110 below.
% % %

clear all;close all;clc;clear classes;
% -o-|-o-|-o-|-o-|-o-|-o-|-o- BEGIN USER-PREFERENCES -o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-
my_root     = 'C:\Bootcamp_featselect';  % Change that to the directory of your project
data_dir= 'C:\Bootcamp_featselect\DATA_CLOP_DEMO';
% data_dir    = [my_root '/DataAgnos'];    % Path to the five data directories downloaded (ADA, GINA, HIVA, NOVA, SYLVA).
resu_dir    = [my_root '/Results']; % Where the results will end up.    
zip_dir     = [my_root '/Zipped'];  % Zipped files with results ready to go!
model_dir   = [my_root '/Models'];  % Where the trained models will end up.
                                    % Note: you have to include the models in
                                    % your submissions for a valid submission.
                                    % In this example, the models are save in full
                                    % in the model_dir directory and a lean
                                    % version (with the hyperparameters and
                                    % the smallest trained entities) is
                                    % save in the resu_dir directory.
disp(my_root);
disp('************************');
code_dir    = ['C:\Bootcamp_featselect\Clop'];    
%  code_dir    = [my_root '/Clop'];    % Path to the sample code or the 
                                    % Challenge Learning Objects Package (CLOP).
score_dir   = [my_root '/Score'];   % Directory where the model scores are found.
ForceOverWrite  = 1;                % Change this value to 0 if you want to be warned when
                                    % a file already exists before saving a result or model.                                 
DoNotLoadTestData   = 1;            % To save memory, does not load the test data
MergeDataSets   = 0;                % If this flag is zero, training is done on the
%                                     % training data only. Otherwise training
%                                     % and validation data are merged. 
FoldNum = 2;  
model_name='PSMS-MODEL';
% %  -o-|-o-|-o-|-o-|-o-|-o-|-o- END USER-PREFERENCES -o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-
fprintf('\n-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-\n');
% Set the path and defaults properly; create directories
% ------------------------------------------------------
addpath(code_dir);
if exist('use_spider_clop.m') == 2, 
    use_spider_clop(code_dir);
elseif exist('code_version.m') == 2, 
    fprintf('Sample code version : %s\n', code_version('sample_code'));
else disp 'ERROR: Wrong code path. Check your directories and path variables.';
    return; 
end
MergeDataSets=0;

% dataset     = {'breast-cancer1','ada', 'gina', 'hiva',  'nova', 'sylva'}; 
% dataset     = {'ada', 'gina', 'hiva',  'nova', 'sylva'}; 
% data_name   = 'breast-cancer1';
data_name   = 'breast-cancer65';
%  data_name   = 'ada';

resu_name   = [resu_dir '/' model_name ];
makedir(resu_name);
resu_name   = [resu_name '/' data_name];

fprintf('-- %s loading data --\n', upper(data_name));
input_dir   = [data_dir '/' upper(data_name)];
input_name  = [input_dir '/' data_name];
D   = create_data_struct(input_name, DoNotLoadTestData);
fprintf('-- %s data loaded --\n', upper(data_name));

debug=0; % Set to 1 to compute the training error in the process of training
guessed_ber=[];       
if MergeDataSets
    % Get rid of the validation set
    if isempty(D.valid.Y), 
        fprintf('!! Cannot merge validation set, labels not available !!\n');
        return
     end
        D.train = data([D.train.X ; D.valid.X], [D.train.Y ; D.valid.Y]);
        rmfield(D, 'valid');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% PSMS Begins %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%% PSMS PARAMETERS %%%%%%%%%%%%%%%%%%%%
% % % SwarmSize
param.swarm_size=10;
param.iterations=35;

% % specify if would you like to create an ensemble 
% % if param.create_ensemble==1 the ensemble is created with the top-k models
% % found through the psms the search process. You should specify 
% % param.save_every = k
param.save_every=5;
% % if param.create_ensemble==2 the ensemble is created with the final
% % swarm
% % The value of k can be modified in the psms.m file (line: a.save_every=1;)
param.create_ensemble=2; %2-1-0
% % specify if would you like to include kridge in the selection process.
% % It is a great algorithm but too expensive computationally
param.include_kridge=0;
param.visualize=1;
% % if fms=1 performs full model selection (preprocessing, feature selection and learning algorithm)
% % if fms=0 performs performs selection of preprocessing and feature
% % % selection methods and hyperparameter optimization of a fixed model (my_model_fixed)
% % if fms=-1 just perfor hyperparameter optimization of a fixed  model(my_model_fixed)
% % Note that my_model_fixed is just a learning-algorithm object (e.g.
% % neural, svc or kridge) it should not include preprocessing or feature
% % selection methods, 
param.fms=1;    
% % % Create a default model
 my_model_fixed=chain({neural});

 %%%%%%%%%%%%%% PSMS %%%%%%%%%%%%%%%%%%%%
% % % Create the object
psms_model    = psms(my_model_fixed,param);
% % % Train the psms object
% % Training psms saves the best models found every iteration in a file named:
% % psms_bestmodels.mat if Matlab gets stacked or you have no more time for
% % searching models you may just load that file (load psms_bestmodels.mat)
% % and get the best model found so far: retRes, or optionally you could
% % create an ensemble with the best k-models found using the following
% % instructions:
% % %  % %  - run psms_usage upto this line 
% % % % %   - then uncomment the following two lines 
% % % % %   - make sure commenting the line: [dat,my_model]=train(psms_model,D.train);
% [num,vecDim,outDim]=get_dim(D.train);       %% Dimensionality of data
% [my_model, combo]=recover_psms(psms_model,D.train,vecDim);
% % % % %   - my_model now will have the best model and combo is the ensemble of top ranked
% % % % %     models

[dat,my_model]=train(psms_model,D.train);% % my_model now contains the best model found by psms 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% End of PSMS %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % We have a model, so lets train and test it!
            cv_ber=[];
            chain_length=[];
            correct_bias=0;
            if FoldNum > 0
            % Create a CV model
            cv_model    = cv(my_model, {['folds=' num2str(FoldNum)], 'store_all=0'});
            fprintf('-- %s-%s performing %d fold cross-validation\n', upper(data_name), upper(model_name), FoldNum);
            % Call the method "train" of the object "cv_model":
            cv_output   = train(cv_model, D.train); 
            % Collect the results
            OutX = []; OutY = []; ber =[];
            for kk = 1:FoldNum,
                outX    = cv_output.child{kk}.X;
                outY    = cv_output.child{kk}.Y;
                OutX    = [OutX; outX]; 
                OutY    = [OutY; outY]; 
                ber(kk) = balanced_errate(outX, outY);
            end
            % Check whether to do a bias correction
            if isa(my_model, 'chain')
                chain_length=length(my_model.child);
                if isa(my_model{chain_length}, 'bias')
                    correct_bias=1;
                end
            end
            if correct_bias
                % Train a bias model with the cv outputs
                [d, cv_bias]=train(bias, data(OutX, OutY));            
                % Compensate the bias
                OutX=OutX+cv_bias.b0;
            end
            % Compute the CV error rate and error bar
            cv_ber   = balanced_errate(OutX, OutY);
            cv_ebar    = std(ber,1)/sqrt(FoldNum);
            fprintf('CV BER=%5.2f+-%5.2f%%\n', 100*cv_ber, 100*cv_ebar); 
            fprintf('-- %s-%s training model on all training data\n', upper(data_name), upper(model_name));
            % Guessing the BER...
            guessed_ber=cv_ber; 
        end
        
        % Train the global model with all the training data
        fprintf('-- %s-%s training model\n', upper(data_name), upper(model_name));
        if ~debug & ~isa(my_model, 'zarbi'), my_model.algorithm.do_not_evaluate_training_error=1; end

        [train_output, my_model]    = train(my_model, D.train);  
        if debug
            [tr_ber, e1, e2, tr_ebar]   = balanced_errate(train_output.X,train_output.Y);
            fprintf('TRAIN BER=%5.2f +-%5.2f%%\n', 100*tr_ber, 100*tr_ebar); 
        end
        
        % Adjust the bias (allowing to compensate for unbalanced classes)
        if correct_bias, 
            my_model{chain_length}.b0=my_model{chain_length}.b0+cv_bias.b0;          
        end
        
        % Save the trained model
        %=======================
        fprintf('-- %s-%s saving the model\n', upper(data_name), upper(model_name));
        mresu_name  = [model_dir '/' model_name];
        makedir(mresu_name);
        mresu_name  = [mresu_name '/' data_name '_model'];
        save_model(mresu_name, my_model, ForceOverWrite, 0);
        % Reload it just to make sure
        my_model    = load_model(mresu_name);
        fprintf('-- %s-%s models saved as %s*\n', upper(data_name), upper(model_name), mresu_name);
        
        % Test the model
        %===============
        if DoNotLoadTestData | MergeDataSets
            % Now (re-)load everything
            D = create_data_struct(input_name);
        end
        set_name    = fieldnames(D); % 'train', 'valid' and 'test'
        for i = 1:length(set_name)
            npat(i)=get_dim(D.(set_name{i}));
        end
        % Merge the datasets into one big test set (this saves time/memory
        % for logitboost
        if isempty(D.valid.Y), D.valid.Y=zeros(npat(2),1); end
        if isempty(D.test.Y), D.test.Y=zeros(npat(3),1); end
        Dtest = data([D.train.X ; D.valid.X ; D.test.X], [D.train.Y ; D.valid.Y ; D.test.Y]);
        clear D;

        % Note: in order to be able to make valid challenge
        % submissions, here we keep the original data split.
        % Thus the training error will differ from the
        % error rate on all the training data and the validation
        % error will be similar to the training error (when the
        % validation data is used for training.)
%         tic;
        fprintf('-- %s-%s testing model\n', upper(data_name), upper(model_name));
        % Call the method "test" of the object "my_model" on data Dtest
        Output  = test(my_model, Dtest);
        ii=1;
        for i = 1:length(set_name) % Loop over training, validation, and test set
            rng=[ii:ii+npat(i)-1];
            ii=ii+npat(i);
            [outx, outy]=get_xy(Output);
            discriminant{i} = outx(rng);
            target = outy(rng);
            if ~isempty(target)
                [ber, e1, e2, sigma] = balanced_errate(discriminant{i},target);
                % Guess that the ber is cv_ber (if cv performed) otherwise
                % train_ber for training set and valid_ber for validation
                % and test set.
                if (isempty(cv_ber) & ~strcmp(set_name{i}, 'test')), guessed_ber=ber; end
                guess_error = challenge_error(guessed_ber, ber);
                score_type = 3;
                score = challenge_error(guessed_ber, ber, score_type, sigma);
                fprintf('%s, BER=%5.2f +-%5.2f%%, guess_error=%5.2f%%, score=%5.2f%%\n', ...
                    set_name{i}, 100*ber, 100*sigma, 100*guess_error, 100*score); 
            end
        end
        clear Dtest;
        
        % Save the results
        %=================
        fprintf('-- %s-%s saving the results\n', upper(data_name), upper(model_name));
        for i=1:length(set_name) % Loop over 'train', 'valid', and 'test'
            save_outputs([[resu_name '_' set_name{i}] '.resu'], sign(discriminant{i}), ForceOverWrite);        
            save_outputs([[resu_name '_' set_name{i}] '.conf'], abs(discriminant{i}), ForceOverWrite);        
        end
        fprintf('-- %s-%s results saved as %s*\n', upper(data_name), upper(model_name), resu_name);
        
        fprintf('\n-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-\n');
        
%% Zip the archives so they are ready to go!
%%-----------------------------------------
if ~usejava('jvm'), warning('Java is not loaded, failed to generate ZIP files !!!'); return; end
    zip_name    = zipall(model_name, resu_dir, zip_dir);
    if ~isempty(zip_name)
        fprintf('-- %s zip archive created, see %s --\n', upper(model_name), zip_name);
    end

% Score the models
fprintf('-- scoring the models --\n');
% simple_score(resu_dir, data_dir, score_dir);


 
