function [d,a] =  training(a,d)

global curr;
global inikern; inikern=0;

if a.algorithm.verbosity>0
    disp(['training ' get_name(a) '.... '])
end
a.dtrain=d;

X=get_x(d); Y=get_y(d); % extract data
n=get_dim(d); % n stores number of examples
alpha=[0]; % alpha_{ij} stores the expansion coefficients (ith example, jth candidate)


xsv=1;ysv=1;  % indices into training set X & Y for svs, and the corresponding labels
for loops=1:a.loops 
    changes=0;
    for i=1:n % for all training examples do 
        curr=i; % global variable stores current option
        r=argmax(a,d,alpha,xsv,ysv,X(i,:));
        
          y=d.Y(i,:); eps=0;
          if (r~=y)   % if pre-image is not the correct one
              if loops==100 keyboard; end;
              changes=changes+1;
              f=find(xsv==i & ysv==y); % find sv for positive example;
              if ~isempty(f)           % if exists, increase alpha
                  alpha(f)=alpha(f)+1;
              else                     % otherwise generate new 'support vector'
                  xsv=[xsv ; i];ysv=[ysv ; y]; alpha=[alpha; 1];
              end   
              f=find(xsv==i & ysv==r); % find sv for negative example;
              if ~isempty(f)           % if exists, decrease alpha
                  alpha(f)=alpha(f)-1;
              else                     % otherwise generate new 'support vector'
                  xsv=[xsv ; i];ysv=[ysv ; r]; alpha=[alpha; -1];
              end   
          end
  end
  disp(sprintf('%d:changes: %d   (svs=%d)', loops, changes,length(xsv)));
  if changes==0 break; end; % finished training - PERFECT!
  end  
  
  a.alpha=alpha;
  a.svs=[xsv ysv];
  a.dat=d;
  curr=Inf;  % stores current index into training set, 
             % in testing we do not have an index
         

if ~a.algorithm.do_not_evaluate_training_error
    d=test(a,d);
end


