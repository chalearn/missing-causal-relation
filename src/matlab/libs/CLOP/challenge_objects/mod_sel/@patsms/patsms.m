function a = patsms(algo,hyper) 

%=====================================================================================
%  Pattern-based search model selection
%=====================================================================================   
%  a=psms(algo,hyperParam) Returns a psms object on algorithm algo using with 
%                        given Hyperparameters. 
% 
%  Possible hyperparameters (with defaults):
% swarmsize=10;             - Number of particles, size of the swarm
% maxiter=100;             - Number of iterations for searching
% c1=2;                     - Weigth for the personal best solution 
% c2=2;                     - Weigth for the Global best solution
% w_start=0.95;             - Starting inertia weight
% w_end=0.4;                - Ending inertia weight
% w_varyfor=0.5;            - Vary for this fraction of iterations, that is
%                             if Iterations=100 and w_varyfor=0.5, the inertia 
%                             weight will be varied for 50 Iterations.                    
% vmax=100;                 - Bound for the Max value of velocity
% TerminateErr=0;           - Error value that should be obtained in order
%                             to stop the search process
% TerminateIter=1;          - If 1, the algorithm will stop until
%                             Iterations have been performed
% a.foldnum=5;               - Number of folds for the cross validation
% a.save_every=1;           - Keep record of the best models every
%                             k-iterations.
% a.fms=1;                  - flag indicating full model selection (fms=1)
%                             or hyperparameter optimization and selection
%                             of preprocessing and feature selection
%                             methods (fms=0), or hyperparameter optimization of
%                             a classifier (fms=-1).
%
%  Model:
%   child                 - stored in child algorithm 
%
%  Methods:
%   train                 - selfexplanatory
%   test                  - no testing method for this clop object
%=====================================================================================
% Reference : Particle swarm model selection, In A. Saffari and I. Guyon editors, JMLR 
%             Special issue on model selection. (2008)
% Author    : Hugo Jair Escalante
% Link      : http://ccc.inaoep.mx/~hugojair
%=====================================================================================

a.IamCLOP=1;

% <<---- Initialisation of Hyperparams ---->>
% % %   Hyperparameters for the Swarm Optimization

a.display_fields={'redfactor',  'maxiter', ...
    'foldnum','fms','tao'};

% <<------hyperparam initialisation------------->> 
a.tao       =    default(-1, [-Inf Inf]);       %  reduction factor
a.redfactor =    default(1, [1 Inf]);       %  reduction factor
a.maxiter   =    default(10, [1 Inf]);      %  maximum # of iterations
                                            % % will wary w

a.foldnum   =    default(5, [1 Inf]);       %  k- in k-fold CV
a.dim       =       default(25, [1 Inf]);   %  reduction factor
a.terminate_err =   default(0, {0, 1});     %  error-termination criteria
a.terminate_itr =   default(1, {0, 1});     %  iters-termination criteria
a.save_every    =   default(5, [1,50]);     %  save every 

a.verbosity =   default(1, {0,1});
a.fms       =   default(1, {-1,0,1});       % Full model selection flag: 
                                            % with a value of -1 pso will
                                            % be used to hyperparameter
                                            % optimization; if 0,
                                            % preprocessing and FS methods
                                            % will be selected; if 1, full
                                            % model selection will be
                                            % performed
a.visualize =   default(1, {0,1});          % vizualization flag
a.defmodel  =   naive;
a.donotincludethis={'svcrfe'};
% a.testdata=testdat;
if ~isunix,
    a.donotincludethis=union(a.donotincludethis,'rf_as');
    a.donotincludethis=union(a.donotincludethis,'gb_rf');
end

% % % If only the algo is specified
if exist('algo','var') & isclop(algo),
    a.child{1}=algo;
else
    a.child{1}=naive;           
end
eval_hyper;
% <<---- convert {} to group({}) ---->>
if isa(a.child{1},'cell') 
      a.child{1}=group(a.child{1}); 
end;

p=algorithm('patsms');
a= class(a,'patsms',p);
