function [d,a] =  training(a,d)

if a.algorithm.verbosity>0
    disp(['training ' get_name(a) '.... '])
end

names=get_x(d); % extract data
numbers = get_y(d);
m=size(names,1); % n stores number of examples
r = a.r; k = a.k; tau = a.tau; t= 0;
%%%% determine size of weight vector %%%%%
load([names(1,:) num2str(1)]); % load data
alpha = zeros(1,size(X,2)); a.alpha = alpha; n = size(X,1);clear X; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for loops=1:a.loops 
    changes=0;
    for i = 1:m
        dtmp = data('tmp',names(i,:),numbers(i));
        dt = test(a,dtmp);% predict ranks with current model
        Y = get_x(dt); U = zeros(size(Y));
        for j = 1:n-1
            for l = j+1:n
                if (j <= r && l >= n-k+1 && Y(j) < Y(l) + tau)
                    U(j) = U(j) + 1;
                    U(l) = U(l) - 1;
                elseif (j >= n-k+1 && l <= r && Y(j) > Y(l) - tau)  
                    U(j) = U(j) - 1;
                    U(l) = U(l) + 1;
                end
            end
        end
        
%         %     subplot(1,2,1)
%         plot(Y)
%         %     subplot(1,2,2)
%         %     plot(U)
%         pause(0.01)
%         
%         a.alpha
        
        if norm(U) > 0
            changes = changes +1;    
            a = update(a, dtmp,U);
        end
        t = t + 1;
    
    end
    
    
    
    
    
    disp(sprintf('%d:changes: %d   (%dth version of alpha)', loops, changes,t));
    if changes==0 break; end; % finished training - PERFECT!
end  


if ~a.algorithm.do_not_evaluate_training_error
    d=test(a,d);
    d.Y = repmat([1:100],m,1);
end


