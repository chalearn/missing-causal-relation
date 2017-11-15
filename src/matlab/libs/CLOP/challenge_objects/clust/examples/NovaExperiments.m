DataMatrix = create_data_struct('d:\Mehreen\NIPS\DataAgnos\nova\nova', 1);
%DataMatrix.train.X = DataMatrix.train.X(1:400,:);
%DataMatrix.train.Y = DataMatrix.train.Y(1:400,:);

FoldNum = 5;
DataMatrix=elim_for_c(DataMatrix,0.3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% describe the models

my_prepro={normalize,shift_n_scale,standardize};
my_neural = neural({'units=20', 'shrinkage=0.005' , 'maxiter=400','balance=0'});
bernoulli_em_model = emBernoulli({'IterationsP=10','IterationsN=10','mixturesP=15','mixturesN=15','EliminatePriors=1e-10','testGivesProb=1'});
SVMModel =  svm({kernel('entropy',.05), 'optimizer="libsvm"',...
                        'C=Inf','algorithm.use_signed_output=0'});
boost_model = gentleboost(my_neural , {'units=5'});
base_model=chain({bernoulli_em_model,my_prepro, my_neural,bias({'option=4'})});                    
cv_model    = cv(base_model, {['folds=',num2str(FoldNum)]});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%train model

[cv_output cv_model]   = train(base_model, DataMatrix.train);
TrainErr = balanced_errate(cv_output.X,cv_output.Y);
out = test(cv_model,DataMatrix.valid);
ValidErr = balanced_errate(out.X,out.Y);
fprintf('\n train error = %f , valid error = %f', TrainErr,ValidErr);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
fprintf('\nTraining CV BER=%5.2f+-%5.2f%%\n', 100*cv_ber, 100*cv_ebar); 

fprintf('\nFor validation set %3.2f+-%5.2f%%\n\n',...
        mean(ber_valid)*100,std(ber_valid,1)/sqrt(FoldNum)*100);
    
        

                        