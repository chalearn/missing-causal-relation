function [results,a] =  training(a,d)
       
  if a.algorithm.verbosity>0
    disp(['training ' get_name(a) '.... '])
  end
  a.Xsv=d;
    
  if a.norm==0
    al=l0;  al.output_rank=0; % use l0 for ||a||_0
    K=get_kernel(a.child,d,[]); d.X=K;
    [results al]=train(al,d); al2=al.child;
    alpha=get_w(al2); r=al.rank; r=r(1:al.feat);
    a.alpha=zeros(size(K,1),1); a.alpha(r)=alpha; a.b0=-al2.b0;
  end
  
  if a.norm==1
    al=loom({'R=0;',a.child}); % use loom without K-diag(K) for ||a||_1
    al.verbosity=0;
    al.ridge=a.ridge; [results al]=train(al,d); 
    a.alpha=al.alpha; a.b0=-al.b0;
  end
  
  if a.norm==2
    al=svm(a.child); al.ridge=a.ridge;  % use svm for ||a||_2
    d.X=get_kernel(a.child,d,[]); 
    [results al]=train(al,d); 
    a.alpha=get_w(al)'; a.b0=-al.b0;
  end
      
  sum(abs(a.alpha)>=1e-4);




