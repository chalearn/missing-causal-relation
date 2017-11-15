    function [D featuresToKeep] = elim_for_c(D,percent)
    
    %percent = % of total that you want to eliminate
    % will do initial binary feature elimination
    % will get rid of features that have <= percentage of non-zeros 
    % also if a feature has > 50% non-zeros and its a binary feature
    % then it will reverse the feature, i.e. make all zeros ones and all
    % ones zeros
    % will also return the list of features to be kept
     
    maxPercent = 100-percent;
    
    %positive values
    xp = D.train.X(D.train.Y>0,:);
    [totalxp features] = size(xp);

    %negative values
    xn = D.train.X(D.train.Y<0,:);
    [totalxn features] = size(xn);
   
    %overall size
    [row col] = size(D.train.X);

    %some counters
    eliminated = 0;
    i=1;
    count = 0;
    featuresToKeep = [];
    
    for i=1:features
        %non-zero attributes in xp
        pxp = find(xp(:,i)~=0);
        %non-zero attributes in xn
        pxn = find(xn(:,i)~=0);
        
        %percentages
        percentxp = length(pxp)/totalxp*100;
        percentxn = length(pxn)/totalxn*100;
        
        %overall percent
        percent_i = (percentxp+percentxn)/2;
        %eliminate with less than a certain percent
   
        if (percentxp <= percent && percentxn <= percent)
            D.train.X(:,i-eliminated)=[];
            if isfield(D,'valid')
                D.valid.X(:,i-eliminated)=[];
            end
            if isfield(D, 'test')
                D.test.X(:,i-eliminated)=[];
            end
            
            eliminated = eliminated+1;
        
        else
            featuresToKeep = [featuresToKeep i];
        end
        
        
    end    
 fprintf('\n-----------DONE INITIAL FEATURE ELIM------Eliminated = %d--------Count = %d', eliminated,count);
 
    
    
    
       