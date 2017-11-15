function [d,a] =  training(a,d)
  
  if a.algorithm.verbosity>0
    disp(['training ' get_name(a) '.... '])
  end
  
 
t = weka.classifiers.trees.RandomForest();
  
[n(1),n(2),n(3)]=get_dim(d);
if(a.numoffeatures==0)
    a.numoffeatures=n(2)
end
tmp=wekaArgumentString({'-I',a.numoftrees,'-K',a.numoffeatures,'-S',a.seed});

t.setOptions(tmp);

%% train classifier
t.buildClassifier(wekaCategoricalData(d));
  
% store
a.tree = t;

if ~a.algorithm.do_not_evaluate_training_error
    d=test(a,d);
end


