function [d,a] =  training(a,d)

if a.algorithm.verbosity>0
    disp(['training ' get_name(a) '.... '])
end

names=get_x(d); % extract data
numbers = get_y(d);
m=size(names,1); % n stores number of examples
tau = a.tau; t= 0;
%%%% determine size of weight vector %%%%%
load([names(1,:) num2str(1)]); % load data
alpha = zeros(1,size(X,2)); a.alpha = alpha; n = size(X,1);clear X; eps = a.eps;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for loops=1:a.loops 
    changes=0;
    for i = 1:m
        dtmp = data('tmp',names(i,:),numbers(i));
        dt = test(a,dtmp);% predict ranks with current model
        Y = get_x(dt); U = zeros(size(Y));
        for j = 1:n-1
            for l = j+1:n
                g_jl = eval([a.margin_control '(j,l)']);
                g_lj = eval([a.margin_control '(l,j)']);
                d_jl = eval([a.d '(j,l)']);
                
                if (j < l && d_jl > eps && Y(j) - Y(l) < g_jl* tau)
                    U(j) = U(j) + g_jl;
                    U(l) = U(l) - g_jl;
                elseif (j > l && d_jl > eps && Y(l) - Y(j) < g_lj* tau)
                    U(j) = U(j) - g_lj;
                    U(l) = U(l) + g_lj;
                end
            end
        end
        
        
        if norm(U) > 0
            changes = changes +1;    
            a = update(a, dtmp,U);
        end
        t = t + 1;
        
        
%         subplot(1,2,1)
%         plot(Y)
%         subplot(1,2,2)
%         plot(U)
%         pause(0.01)
%         
%         a.alpha
        
        
    end
    
    
    
    
    
    disp(sprintf('%d:changes: %d   (%dth version of alpha)', loops, changes,t));
    if changes==0 break; end; % finished training - PERFECT!
end  


if ~a.algorithm.do_not_evaluate_training_error
    d=test(a,d);
    d.Y = repmat([1:100],m,1);
end



%%%%% HELPER FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%



%%%%% margin control %%%%%%%%%%%%%%%%%%%%%%
function ret = inverse_index_difference(p,q)
    ret = p^(-1) - q^(-1);

%%%%% distance function %%%%%%%%%%%%%%%%%%%
function ret = abs_rank_diff(yi,yj)
    ret = abs(yi-yj);