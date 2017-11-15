function weig = get_w(sv,method) 
% w = get_w(sv)
% High value of w means big decrease in the margin.
% Warning: do not return values of w here. Return a score for each feature
% use the max, change max into sum should not change a lot.
% can be used only if same kernel for all base machines
%% method = 1 ->  take the sum
%% method = 2 ->  used for the l0 update, where the get_w is different from rfe
if nargin < 2,
    method = 1;
end;
if method<2,
    
    ke=sv.child;
    alphaTemp = sv.alpha;
    Q = size(alphaTemp,2);
    kerTemp = ke.kerparam;
    KTemp = get_kernel(ke,sv.Xsv,sv.Xsv);
    if strcmp(ke.ker,'linear')|strcmp(ke.ker,'weighted_linear'),
      % compute the multi-class margin for each feature removed.
        if strcmp(ke.ker,'weighted_linear'),
            xTemp = get_x(sv.Xsv);
            xTemp = xTemp.*(ones(size(xTemp,1),1)*ke.kerparam);    
            KTemp = xTemp*xTemp';
        end;
        xTemp = get_x(sv.Xsv);
        temp=xTemp'*alphaTemp;
        temp2=xTemp'*sum(alphaTemp,2);
        weig = sum(temp.^2,2)' + 1/Q*(temp2.^2)';
        weig = max(weig)-weig;
        return;
    else
        if strcmp(ke.ker,'rbf'),       
          % compute the kernel matrix for all components
          
          xTemp = get_x(sv.Xsv);
          
          temp=zeros(1,Q);
          for j=1:Q,
              temp(j)=alphaTemp(:,j)'*(KTemp)*alphaTemp(:,j);                
          end;
          temp = sum(temp) + 1/Q*(sum(alphaTemp,2)'*KTemp*sum(alphaTemp,2));
                                        
          % compute the margin when one component is removed
            for i = 1:size(xTemp,2),
               Ki = xTemp(:,i)*ones(1,size(xTemp,1)) - ones(size(xTemp,1),1)*xTemp(:,i)';
               Ki = Ki.^2;
               Ki = Ki/(2*kerTemp^2); 
               Ki = exp(Ki);
               for j=1:Q,
                temp_i(j)=alphaTemp(:,j)'*(KTemp.*Ki)*alphaTemp(:,j);                
               end;
                temp_i = sum(temp_i) + 1/Q*(sum(alphaTemp,2)'*(KTemp.*Ki)*sum(alphaTemp,2));                
               weig(i) = temp-temp_i;              
            end;
            weig = max(weig)-weig;
           return;    
        elseif strcmp(ke.ker,'poly'),
            xTemp = get_x(sv.Xsv);        
            
            temp=zeros(1,Q);
              for j=1:Q,
                  temp(j)=alphaTemp(:,j)'*(KTemp)*alphaTemp(:,j);                
              end;
          temp = sum(temp) + 1/Q*(sum(alphaTemp,2)'*KTemp*sum(alphaTemp,2));        
            for i = 1:size(xTemp,2),
               Ki = xTemp(:,i)*xTemp(:,i)';
               K_i = (KTemp - Ki + 1).^(kerTemp);         
               for j=1:Q,
                temp_i(j)=alphaTemp(:,j)'*(Ki)*alphaTemp(:,j);                
               end;
                temp_i = sum(temp_i) + 1/Q*(sum(alphaTemp,2)'*(Ki)*sum(alphaTemp,2));                
               weig(i) = temp-temp_i;              
            end;
           weig=max(weig)-weig;
           return;
        end;% if strcmp(...,'rbf')
    end;% if strcmp(...,'linear')
%%% Otherwise, all classic kernels have been computed. Now use the get_kernel generically
if strcmp(ke.ker,'custom'),
    error('Get w not implemented for CUSTOM kernels.');
    return;
end;
% compute the multi-class margin for each feature removed.
     
   xTemp = get_x(sv.Xsv);
   temp=zeros(1,Q);              
   for j=1:Q,
          temp(j)=alphaTemp(:,j)'*(KTemp)*alphaTemp(:,j);                
   end;
   temp = sum(temp) + 1/Q*(sum(alphaTemp,2)'*KTemp*sum(alphaTemp,2));        
  
    
   for i = 1:size(xTemp,2),
       dtmp = data('temp',[xTemp(:,1:(i-1)),xTemp(:,(i+1):size(xTemp,2))],[]);
       Ki = get_kernel(ke,dtmp,dtmp);             
       for j=1:Q,
            temp_i(j)=alphaTemp(:,j)'*(Ki)*alphaTemp(:,j);                
       end;
       temp_i = sum(temp_i) + 1/Q*(sum(alphaTemp,2)'*(Ki)*sum(alphaTemp,2));                
       weig(i) = temp-temp_i;                          
   end;   
   weig=max(weig)-weig;
return;
else, %% if method < 3
    %% method for the multiplicative update
    alphaTemp = sv.alpha;
    W = abs(get_x(sv.Xsv)'*alphaTemp);          
    weig = sum(W,2);
    weig=weig';    
end;
