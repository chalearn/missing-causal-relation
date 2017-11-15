    function DataMatrix=bin_features(algo,DataMatrix)

    %first check if this step has already been performed
    if (isfield(DataMatrix,'type'))
        if (DataMatrix.type == 0)
            return;
        end
    end

    
    % will get rid of all non-binary features
    
       
    [row col] = size(DataMatrix.X);
    eliminated = 0;
    i=1;
    
    while (i<=col-eliminated)
        [m2 n2] = size(find(DataMatrix.X(:,i)~=1 & DataMatrix.X(:,i)~=0));
        if (m2>0)
            DataMatrix.X(:,i)=[];
            eliminated = eliminated+1;
        else
            i = i+1;
        end
    end
    
    DataMatrix.type = 0;
   %....eliminated continuous features
   fprintf('\n-----------DONE...Eliminated = %d cont features', eliminated);