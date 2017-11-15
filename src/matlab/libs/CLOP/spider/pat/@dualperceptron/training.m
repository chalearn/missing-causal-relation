function [d,a] =  training(a,d)
  
  if a.algorithm.verbosity>0
    disp(['training ' get_name(a) '.... '])
  end
  
  [m n k]=get_dim(d);
 
  Y=get_y(d); pred=Y*0; alpha=Y*0; 
  a.error=Y*0;
  
  for loops=1:a.max_loops
   changes=0; 
   for i=1:m
      a.error(i)=0;
      if Y(i)*pred(i)<=a.margin   % error, update alphas
           alpha(i)=alpha(i)+Y(i);
           a.error(i)=1;
           ind=1:m;
           if loops==a.max_loops % if this is the last sweep, we only have
               ind=i+1:m;        % to update vectors we haven't  seen yet
           end       
           if ~isempty(ind)
               pred(ind)=pred(ind)+Y(i)*calc(a.child,get(d,i),get(d,ind));
           end
           changes=changes+1;
      end
   end 
   if a.algorithm.verbosity>0 
       disp(sprintf('%d:changes: %d   (svs=%d) (errs=%d)', loops, changes,sum(abs(alpha)>0),sum((Y .* pred)<0)));
   end
   if changes==0 break; end; % finished training - PERFECT!
  end
  
fin=find(abs(alpha)>a.alpha_cutoff);
a.alpha=alpha(fin);
a.Xsv=get(d,fin);
 
if a.algorithm.do_not_evaluate_training_error
    d=set_x(d,get_y(d)); 
else
    d=test(a,d);
end

  
