function [d,a] =  training(a,d)
  
  if a.algorithm.verbosity>0
    disp(['training ' get_name(a) '.... '])
  end
  
  [m n k]=get_dim(d);
 
  Y=get_y(d); pred=Y*0; alpha=Y*0; svs=[]; 
  Kcache=zeros(a.cache_size+1,a.cache_size+1);
    
  for loops=1:a.max_loops  
   changes=0;
   for i=1:m
      % calc dist from margin of example i
       dist=0;
       if ~isempty(svs) 
         K=calc(a.child,get(d,i),get(d,svs));
         dist=sum(alpha(svs).*K);
       end
       if dist*Y(i)<=a.margin   % if error, update alphas
           
           % Update svs with a_i k(x_i,x) apart from sv i itself
           %  - thus we know the distance from the margin for every sv 
           %    we will delete the ones that
           %    are still > margin (condense) after removing own influence

           ind1=svs;
           if ~ismember(i,svs)
            if ~isempty(svs)
                Kcache(1:length(svs),length(svs)+1)=K;
                Kcache(length(svs)+1,1:length(svs))=K';
            end
            svs=[svs i]; 
           end
           alpha(i)=alpha(i)+Y(i); 
           
           pred(i)=dist; % distance from marg of new guy includes apart
                         % from his own influence
           if length(svs)>1
            %pred(ind)=pred(ind)+Y(i)*calc(a.child,get(d,i),get(d,ind));
            pred(ind1)=pred(ind1)+Y(i)*K;
           end
           oldsvs=svs;
           
  
           if ~isempty(a.cache_size) & length(svs)==a.cache_size+1 

           [f1 f]=max(Y(svs) .* pred(svs)); % find point furthest from margin 
           if f1>a.margin | ~isempty(a.cache_size) %as long as > than margin.. REMOVE!
                                                   %OR if have max cache size..REMOVE!
             f2=f;  svinds=setdiff(1:length(svs),f2);            
             f=svs(f); svs=setdiff(svs,f);            
             pred(svs)=pred(svs)-alpha(f)*Kcache(svinds,f2);
             Kcache=Kcache(svinds,svinds);
             alpha(f)=0; 
           end
           end 
           
           changes=changes+1;
           if a.algorithm.verbosity>1
               disp(sprintf('compressed svs: %d -> %d', length(oldsvs), length(svs)));
            end
       end
   end 
   if a.algorithm.verbosity>0 
       disp(sprintf('%d:changes: %d   (svs=%d)', loops, changes,sum(abs(alpha)>0)));
   end
   if changes==0 break; end; % finished training - PERFECT!
  end
  
fin=svs;
a.alpha=alpha(fin);
a.Xsv=get(d,fin);
 
if a.algorithm.do_not_evaluate_training_error
    d=set_x(d,get_y(d)); 
else
    d=test(a,d);
end

  
