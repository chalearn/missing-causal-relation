function  [ret,alg] =  training(alg,dat)

  alg.store_all=1;
  [ret,alg.child{1}] =  train(alg.child{1},dat);
