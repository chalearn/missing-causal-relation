function  [ret] =  testing(alg,dat)
  
  if alg.store_all==0
    error('cannot run test on param object when store_all=0')
  end
  [ret] =  test(alg.child{1},dat);
