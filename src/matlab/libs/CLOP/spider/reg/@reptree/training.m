function [d,a] =  training(a,d)
  
  if a.algorithm.verbosity>0
    disp(['training ' get_name(a) '.... '])
  end
  
 
t = weka.classifiers.trees.REPTree();
  
tmp=wekaArgumentString({'-M',a.minleaf,'-V',a.minvar,'-N',a.folds,'-S',a.seed,'-L',a.maxdepth});
if(a.pruning==0)
    tmp=wekaArgumentString({'-P',''},tmp);
end
t.setOptions(tmp)
%% train classifier
t.buildClassifier(wekaNumericalData(d));
  
% store
a.tree = t;
a.feats=wekaGetFeaturesFromGraph(t);

if ~a.algorithm.do_not_evaluate_training_error
    d=test(a,d);
end


