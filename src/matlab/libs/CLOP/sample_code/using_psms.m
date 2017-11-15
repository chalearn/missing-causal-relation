% % % % 
% % % % 
% % % % A simple script that allows running PSMS (Particle Swarm Model 
% % % % Selection) for a given data set.
% % % % 
% % % % This implementation allows:
% % % %             1) hyperparameter optimization (fms=-1)
% % % %             2) selection of preprocessing and feature selection 
% % % %                 methods for a fixed classifier (fms=0)
% % % %             3) full model selection (fms=1)
% % % % 
% % % % 
% % % % Authors:    Hugo Jair Escalante,  Isabelle Guyon and Amir Saffari
% % % % Contact:    hugojair@ccc.inaoep.mx
% % % % Date:   August 26, 2008.
% % % % 

clear all; close all; clc;
global ud;
% % % %  Go to the directory where CLOP is located
ud.path2clop='C:\Clop_v1.5\CLOP';
cmd=['cd ' ud.path2clop];eval(cmd);clear cmd;
% % % %  Add CLOP to the path
use_spider_clop;
% % % %  Default data set name 
ud.thisdataset='thyroid';
% % % % Directory to where the data is located
ud.datadir=[ud.path2clop '\data_mlss08\'];
ud.results_dir=[ud.path2clop '\Results\mlss08\'];

% % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % Set the default PSMS parameters % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % Search iterations
ud.itera=10;
% % % Swarm size 
ud.ttsize=5;
% % % subsampling factor (for large data sets use ud.redfacts>2)
ud.redfacts=1;
% % % FMS flag: -1) hyperparameter optimization; 0) selection of
% % % preprocessing and feature selection method; 1) full model selection
ud.fmss=-1;
% % % Number of folds when computing the fitness function
ud.folds=2;
% % % Local weight for updating velocities
ud.c1=2;
% % % Global weight for updating velocities
ud.c2=2;
% % % Model name 
ud.model_name=neural;
% % % Starting inertia weight
ud.wi=1.2;
% % % Ending inertia weight
ud.we=0.4;
% % % Vary W for ud.wvf fraction of iterations
ud.wvf=0.5;
% % % If you want to visualize a plot at the end of the search
ud.visualize=1;

% % % % Remove all R files
% rlinkdire='C:\CLOP\challenge_objects\packages\Rlink';
% cmd=['del ' rlinkdire '\*.Rdata'];
% system(cmd);

warning off all;

% % % % Name of the data 
ud.data_name=ud.thisdataset;
% % % % Load the dataset and create the train and test sets    
ud.tdataname=[ud.datadir ud.thisdataset '\'];
da=importdata([ud.tdataname '\' ud.data_name '_train.DATA']);
db=importdata([ud.tdataname '\' ud.data_name '_train.LABELS']);
ud.D.train=data(da,db);
clear da db;
da=importdata([ud.tdataname '\' ud.data_name '_test.DATA']);
db=importdata([ud.tdataname '\' ud.data_name '_test.LABELS']);
ud.D.test=data(da,db);    
clear da db;

% % % % Create the PSMSx object, according the parameters specified
ud.X=psmsx(ud.model_name,{['visualize=' num2str(ud.visualize)],['maxiter=' ...
    num2str(ud.itera)],['swarmsize=' num2str(ud.ttsize)],['foldnum=' ...
    num2str(ud.folds)],['redfactor=' num2str(ud.redfacts)],['c1=' ...
    num2str(ud.c1)],['c2=' num2str(ud.c2)],['w_start=' num2str(ud.wi)],...
    ['w_varyfor=' num2str(ud.wvf)],['w_end=' num2str(ud.we)],...
    ['fms=' num2str(ud.fmss)]});
% % % % % Uncomment the following lines to use pattern search for model
% % % % % selection
% % % % % Create the PATSMS object, according the parameters specified
% ud.n_iter=ud.itera.*ud.ttsize;
% ud.X=patsms(ud.model_name,{['visualize=' num2str(ud.visualize)],['maxiter=' ...
%     num2str(ud.n_iter)],['foldnum=' ...
%     num2str(ud.folds)],['redfactor=' num2str(ud.redfacts)],...
%     ['fms=' num2str(ud.fmss)]});

% % % What's the current time
ud.itime=cputime;
% % % Train the PSMSx object (i. e. perform model selection)
[ud.aa,ud.my_model]=train(ud.X,ud.D.train);
ud.timexc=cputime-ud.itime;
% % % Train the selected model
[ud.aa,ud.bb]=train(ud.my_model.Best_model,ud.D.train);
% % % Test-it on training data
[ud.train_result]=test(ud.bb,ud.D.train);
% % % Test-it on testing data
[ud.test_result]=test(ud.bb,ud.D.test);
% % % What is the CV error of the selected model
ud.ber_cv = ud.my_model.fBest;
% % % What is the train error of the selected model
ud.ber_train=balanced_errate(ud.train_result.X, ud.train_result.Y);
% % % What is the train error of the selected model
ud.ber_test=balanced_errate(ud.test_result.X, ud.test_result.Y);
% % % Which are the "valid models"
valid_tracks=find(ud.my_model.track~=100);
% % % What is the mean CV error obtained during the search
ud.mean_cv= mean(ud.my_model.track(valid_tracks));

warning on all;

fprintf('-o-o-o-o-o-o-o-o-o-o-o-o\n');
fprintf('Model selection took %6.2f Seconds \n',ud.timexc);
fprintf('The CV error of the selected model is %6.2f \n',ud.ber_cv.*100);
fprintf('The Training error of the selected model is %6.2f \n',ud.ber_train.*100);
fprintf('The Testing  error of the selected model is %6.2f \n',ud.ber_test.*100);
fprintf('Average CV error during the search %6.2f \n',ud.mean_cv.*100);
fprintf('-o-o-o-o-o-o-o-o-o-o-o-o\n');
ud.my_model.Best_model