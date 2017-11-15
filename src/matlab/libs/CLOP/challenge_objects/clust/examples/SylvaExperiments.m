DataMatrix = create_data_struct('d:\Mehreen\NIPS\DataAgnos\sylva\sylva', 1);
%DataMatrix.train.X = DataMatrix.train.X(1:400,:);
%DataMatrix.train.Y = DataMatrix.train.Y(1:400,:);

%DataMatrix=elim_for_c(DataMatrix,5);

%make one big matrix of train and test data
DataMatrix.train.X = [DataMatrix.train.X;DataMatrix.valid.X];
DataMatrix.train.Y = [DataMatrix.train.Y;DataMatrix.valid.Y];

FoldNum = 5;

DataMatrix=elim_for_c(DataMatrix,1);
my_prepro={standardize,shift_n_scale,normalize};
my_neural = neural({'units=10', 'shrinkage=0.003' , 'maxiter=500','balance=0'});
gauss_em_model = emGauss({'IterationsP=30','IterationsN=30','mixturesP=6','mixturesN=6'}); 
bernoulli_em_model = emBernoulli({'IterationsP=40','IterationsN=40','mixturesP=3','mixturesN=3','EliminatePriors=1e-10','testGivesProb=1'});
em_model = emAll({gauss_em_model,bernoulli_em_model},{'testGivesProb=1'});            
base_model=chain({em_model,my_prepro{:}, my_neural,bias});
cv_model    = cv(base_model, {['folds=',num2str(FoldNum)]});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%try the cv model

% Call the method "train" of the object "cv_model":
[cv_output cv_model]   = train(cv_model, DataMatrix.train);
TrainErr = balanced_errate(cv_output.X,cv_output.Y);
out = test(cv_model,DataMatrix.valid);
ValidErr = balanced_errate(out.X,out.Y);
fprintf('\n train error = %f , valid error = %f', TrainErr,ValidErr);

% Collect the results
OutX = []; OutY = []; ber =[];
for kk = 1:FoldNum,
    outX    = cv_output.child{kk}.X;
    outY    = cv_output.child{kk}.Y;
    OutX    = [OutX; outX]; 
    OutY    = [OutY; outY]; 
    ber(kk) = balanced_errate(outX, outY);
end
% Compute the CV error rate and error bar
cv_ber   = balanced_errate(OutX, OutY);
cv_ebar    = std(ber,1)/sqrt(FoldNum);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%test on the validation set

out = test(cv_model,DataMatrix.valid);
for i=1:1:FoldNum
    ber_valid(i) = balanced_errate(out{i}.X,out{i}.Y);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%output them
fprintf('Training CV BER=%5.2f+-%5.2f%%\n', 100*cv_ber, 100*cv_ebar); 

fprintf('\nFor validation set %3.2f+-%5.2f%%\n\n',...
        mean(ber_valid)*100,std(ber_valid,1)/sqrt(FoldNum)*100);
    

