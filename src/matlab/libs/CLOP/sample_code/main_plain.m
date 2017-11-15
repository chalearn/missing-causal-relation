% -o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-
%                               SAMPLE CODE FOR THE BOOK 
%                           "HANDS ON PATTERN RECOGNITION: 
% challenges in data representation, model selection, and performance prediction"     
% Isabelle Guyon, Gavin Cawley, Gideon Dror, and Amir Saffari (Book Editors/CLOP authors)
% Inquiries: isabelle@clopinet.com
% Acknowledgements: Many thanks to all the contributors of the Spider and to 
% Hugo Hair Escalante for contribution the PSMS object and testing the sample code.
%                                   March 2008
% -o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-

% DISCLAIMER: ALL INFORMATION, SOFTWARE, DOCUMENTATION, AND DATA ARE PROVIDED "AS-IS" 
% ISABELLE GUYON AND/OR OTHER CONTRIBUTORS DISCLAIM ANY EXPRESSED OR IMPLIED WARRANTIES, 
% INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS 
% FOR ANY PARTICULAR PURPOSE, AND THE WARRANTY OF NON-INFRIGEMENT OF ANY THIRD PARTY'S 
% INTELLECTUAL PROPERTY RIGHTS. IN NO EVENT SHALL ISABELLE GUYON AND/OR OTHER CONTRIBUTORS 
% BE LIABLE FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER
% ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF SOFTWARE, DOCUMENTS, 
% MATERIALS, PUBLICATIONS, OR INFORMATION MADE AVAILABLE FOR THE CHALLENGE AND THE BOOK. 
%
% NOTE: This code reads and processes data for the "agnostic track" of the ALvsPK challenge.
%
% ---------
% Tested and modified by: 
% Gideon Dror, gideon@mta.ac.il
% Amir Reza Saffari Azar, amir@ymer.org.
% May 2006
% ---------

%% Initialization
clear all
close all
%clc

% -o-|-o-|-o-|-o-|-o-|-o-|-o- BEGIN USER-PREFERENCES -o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-

% 1) User-defined directories (no slash at the end of the names):
% --------------------------------------------------------------
% The present set up supposes that you are now in the directory sample_code
% and you have the following directory tree, where Challenge is you project directory:
% Challenge/Data
% Challenge/Results
% Challenge/Zipped
% Challenge/Models
% Challenge/Clop
% Challenge/Clop/sample_code

my_root     = '../..';  % Change that to the directory of your project

data_dir    = [my_root '/DataAgnos_w_labels'];    %  DataAgnos Path to the five data directories downloaded (ADA, GINA, HIVA, NOVA, SYLVA).
resu_dir    = [my_root '/Results']; % Where the results will end up.    
zip_dir     = [my_root '/Zipped'];  % Zipped files with results ready to go!
model_dir   = [my_root '/Models'];  % Where the trained models will end up.
code_dir    = [my_root '/Clop'];    % Path to the sample code or the 
                                    % Challenge Learning Objects Package (CLOP).
score_dir   = [my_root '/Score'];   % Directory where the model scores are found.

ForceOverWrite  = 1;                % Change this value to 0 if you want to be warned when
                                    % a file already exists before saving a result or model.
                                    
DoNotLoadTestData   = 1;            % To save memory, does not load the test data

MergeDataSets   = 0;                % If this flag is zero, training is done on the
                                    % training data only. Otherwise training
                                    % and validation data are merged. 

FoldNum = 0;                        % If this flag is positive, 
                                    % k-fold cross-validation is performed.
                                    % with k=FoldNum.
CorrectBias=0;                      % Post fitting of the bias by cross-validation
                                    % Works only if FoldNum>0

% 2) Choose your data and models
% ------------------------------
dataset     = {'sylva'};%, 'gina', 'hiva',  'nova', 'sylva'}; %'gina', 'hiva',  'nova', 'sylva'
modelset    = {'LB'}; % 'KLR','LB','RF','LSSVM','KRR', 'KRIDGE', 'RF', 'LB'
                                    % This should be an array of model example names
                                    % e.g. {'zarbi', 'naive'};
                                    % If you leave this array is empty, it will 
                                    % be replaced by a default list of model names.                              
                                    % For a list of model examples, use:
                                    % > model_examples

% -o-|-o-|-o-|-o-|-o-|-o-|-o- END USER-PREFERENCES -o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-
fprintf('\n-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-\n');

% Set the path and defaults properly; create directories
% ------------------------------------------------------
warning off; addpath(code_dir); warning on;
if exist('use_spider_clop.m') == 2, 
    use_spider_clop(code_dir);
elseif exist('code_version.m') == 2, 
    fprintf('Sample code version : %s\n', code_version('sample_code'));
else disp 'ERROR: Wrong code path. Check your directories and path variables.';
    if exist('README.txt') == 2, type README.txt; end
    if exist('Data/README.txt') == 2, type Data/README.txt; end
    if exist('Clop/README.txt') == 2, type Clop/README.txt; end
    return; 
end
if isempty(modelset), modelset =  model_examples; end
makedir(resu_dir);
makedir(zip_dir);
makedir(model_dir);
makedir(score_dir);

%% Train/Test
% LOOP OVER DATASETS 
% ===================
for k = 1:length(dataset)
    
	data_name   = dataset{k};
    
    fprintf('\n-o-|-o-|-o-|-o-|-o-|-o-      %s      -o-|-o-|-o-|-o-|-o-|-o-\n', upper(data_name));
    fprintf('\n-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-\n\n');
    %disp(data_dir)

    % LOOP OVER MODELS 
    % ================
    for j = 1:length(modelset)
        
        model_name  = modelset{j};
        
        resu_name   = [resu_dir '/' model_name ];
        makedir(resu_name);
        resu_name   = [resu_name '/' data_name];
        
        % Create a data structure and check the data
        %===========================================
        % Note: it may seem waistful to reload the data every time.
        % This is done because of memory management problems.
        fprintf('-- %s loading data --\n', upper(data_name));
        input_dir   = [data_dir '/' upper(data_name)];
        input_name  = [input_dir '/' data_name];

        D   = create_data_struct(input_name, DoNotLoadTestData);
        % Each member of D (D.train, D.valid, and D.test) 
        % is a data object (a structure) with members X and Y (if Y is given). 

        % New: compute data statistics
        data_stats(D);

        fprintf('-- %s data loaded --\n', upper(data_name));
        % Note: the data are saved as a Matlab structure 
        % so they will load faster the second time around. 

        % Build a model
        %==============
        fprintf('-- %s-%s building  model\n', upper(data_name), upper(model_name));
        % "model_examples" calls a model constructor and returns a learning object.
        % Enter at the prompt "> type model_examples" to view the examples.
        % All learning objects have the two methods "train" and "test".
        % To see the data members, type at the prompt "> struct(my_model)".
        my_model    = model_examples(model_name, data_name);
        % Save the model (untrained) in the result file
        save_model([resu_name , '_model'], my_model, ForceOverWrite, 0);
        % Reload it just to make sure
        my_model    = load_model([resu_name , '_model']);
        fprintf('-- %s-%s model built\n', upper(data_name), upper(model_name));
        
        % Train the model
        %================
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
            if isa(my_model, 'chain') & CorrectBias
                chain_length=length(my_model.child);
                if isa(my_model{chain_length}, 'bias')
                    correct_bias=1;
                end
            end
            if correct_bias
                fprintf('== CV post-fitting of the bias ==\n');
                % Train a bias model with the cv outputs
                [d, cv_bias]=train(bias, data(OutX, OutY));            
                % Compensate the bias
                OutX=OutX+cv_bias.b0;
            end
            % Compute the CV error rate and error bar
            cv_ber   = balanced_errate(OutX, OutY);
            cv_ebar    = std(ber,1)/sqrt(FoldNum);
            fprintf('CV BER=%5.2f+-%5.2f%%\n', 100*cv_ber, 100*cv_ebar); 
            fprintf('-- %s-%s cross-validation done in %5.2f seconds\n', upper(data_name), upper(model_name), toc);
            fprintf('-- %s-%s training model on all training data\n', upper(data_name), upper(model_name));
            % Guessing the BER...
            guessed_ber=cv_ber; 
        end
        
        % Train the global model with all the training data
        fprintf('-- %s-%s training model\n', upper(data_name), upper(model_name));
        if ~debug & ~isa(my_model, 'zarbi'), my_model.algorithm.do_not_evaluate_training_error=1; end
        tic;
        [train_output, my_model]    = train(my_model, D.train);  
        if debug
            [tr_ber, e1, e2, tr_ebar]   = balanced_errate(train_output.X,train_output.Y);
            fprintf('TRAIN BER=%5.2f +-%5.2f%%\n', 100*tr_ber, 100*tr_ebar); 
        end
        fprintf('-- %s-%s model trained in %5.2f seconds\n', upper(data_name), upper(model_name), toc);
        
        % Adjust the bias (allowing to compensate for unbalanced classes)
        if correct_bias, 
            fprintf('== Adjusting the bias ==\n');
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
        %my_model    = load_model(mresu_name);
        fprintf('-- %s-%s models saved as %s*\n', upper(data_name), upper(model_name), mresu_name);
        
        % Test the model
        %===============
        if 1==2
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
        tic;
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
        fprintf('-- %s-%s model tested in %5.2f seconds\n', upper(data_name), upper(model_name), toc);  
        clear Dtest;
        end %if 1==2
        
        if DoNotLoadTestData | MergeDataSets
            % Now (re-)load everything
            D = create_data_struct(input_name);
        end
        tic;
        fprintf('-- %s-%s testing model\n', upper(data_name), upper(model_name));
        set_name    = fieldnames(D); % 'train', 'valid' and 'test'

        for i = 1:length(set_name) % Loop over training, validation, and test set
            % Call the method "test" of the object "my_model" 
            % on D.train, D.valid, or D.test:
            output  = test(my_model, D.(set_name{i})); 
            discriminant{i} = output.X; % The "test" method returns the predicted discriminant values in output.X
            target = output.Y; % If the targets were provided in the dataset, they are copied in output.Y
            if ~isempty(target)
                ber = balanced_errate(discriminant{i},target);
                ebar = error_bar(ber, length(find(target>0)));
                fprintf('%s, BER=%5.2f +-%5.2f%%\n', set_name{i}, 100*ber, 100*ebar); 
            end
        end 
        fprintf('-- %s-%s model tested in %5.2f seconds\n', upper(data_name), upper(model_name), toc);  

        % Save the results
        %=================
        fprintf('-- %s-%s saving the results\n', upper(data_name), upper(model_name));
        for i=1:length(set_name) % Loop over 'train', 'valid', and 'test'
            save_outputs([[resu_name '_' set_name{i}] '.resu'], sign(discriminant{i}), ForceOverWrite);        
            save_outputs([[resu_name '_' set_name{i}] '.conf'], abs(discriminant{i}), ForceOverWrite);        
        end
        fprintf('-- %s-%s results saved as %s*\n', upper(data_name), upper(model_name), resu_name);
        
        fprintf('\n-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-\n');
        
    end % Loop over models
end % Loop over datasets

%% Zip the archives so they are ready to go!
%%-----------------------------------------
if ~usejava('jvm'), warning('Java is not loaded, failed to generate ZIP files !!!'); return; end
for k = 1:length(modelset)
    model_name  = modelset{k};
    zip_name    = zipall(model_name, resu_dir, zip_dir);
    if ~isempty(zip_name)
        fprintf('-- %s zip archive created, see %s --\n', upper(model_name), zip_name);
    end
end

% Score the models
fprintf('-- scoring the models --\n');
%score_n_compare(resu_dir, data_dir, score_dir);
%simple_score(resu_dir, data_dir, score_dir);
