function [dat, alg] =  training(alg,dat)
%[dat, alg] =  training(alg,dat)
% Feature selection with cal_rfe ranking.
% Returns the training data dat restricted to the
% selected features.

% Isabelle Guyon -- isabelle@clopinet.com -- April 2013
  
if alg.algorithm.verbosity>1
    logfile =1;
else
    logfile=0;
end

if ~isempty(alg.cache_file) && (exist(alg.cache_file, 'file') || exist([alg.cache_file '.mat'], 'file'))
    if alg.algorithm.verbosity>0
        fprintf('Loading: %s\n', alg.cache_file);
    end
    load(alg.cache_file);
else
    if alg.algorithm.verbosity>0
        disp(['training ' get_name(alg) '... '])
    end
    
    % Select model
    y=get_y(dat);
    if length(unique(y))==2
        alg.UNI=alg.UNICLA;
    else
        alg.UNI=alg.UNIREG;
    end
    
    % Compound model
    mymodel=chain({alg.UNI, alg.RFE});
    [d2, mymodel]=train(mymodel, dat);
    fidx=get_fidx(mymodel);
    W=get_w(mymodel, 1); % the weights come ordered the same as the indices
    
    
    % Eventually add calibrants
    if length(fidx)<alg.f_max
        
        fcal=[];
        wcal=[];
        funi=[];
        wuni=[];
        % This is similar to balance == 3
        %    [~, unimodel]=train(calibrant(['f_max=' num2str(alg.f_max/2)]), dat); 
        %    funi=get_fidx(unimodel);
        %    wuni=get_w(unimodel, 1);
        if alg.balance==4
            [~, calmodel]=train(calibrant({d2, ['f_max=' num2str(alg.f_max/2)]}), dat); 
            fcal=get_fidx(calmodel);
            wcal=get_w(calmodel, 1);
        elseif alg.balance==5
            [~, unimodel]=train(calibrant(['f_max=' num2str(alg.f_max/4)]), dat); 
            funi=get_fidx(unimodel);
            wuni=get_w(unimodel, 1); 
            [~, calmodel]=train(calibrant({d2, ['f_max=' num2str(alg.f_max/4)]}), dat); 
            fcal=get_fidx(calmodel);
            wcal=get_w(calmodel, 1);
        end

        fidx=[fidx(1:alg.f_max/4), fcal, funi, fidx(end-alg.f_max/4+1:end)];
        W=[W(1:alg.f_max/4), wcal, wuni, W(end-alg.f_max/4+1:end)];
        
    end
           
    alg.fidx=fidx;
    alg.W=[];
    alg.W(alg.fidx)=W; % Reorder the weights properly!

    
    % Cache results
    if ~isempty(alg.cache_file)
        save(alg.cache_file, 'idx', 'W');
    end

end
  
dat=test(alg, dat);



  

  
  
