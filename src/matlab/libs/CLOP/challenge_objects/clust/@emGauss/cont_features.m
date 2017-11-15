    function DataMatrix=cont_features(algo,DataMatrix)    
    
    %check if binary features have already been eliminated
    if (isfield(DataMatrix,'type'))
        if (DataMatrix.type == 1)
            return;
        end
    end
    % will get rid of all binary features
    [row col] = size(DataMatrix.X);
    eliminated = 0;
    i=1;
    
    while (i<=col-eliminated)
        %find out values that are not zero and not one...that is continuous
        %features
        [m2 n2] = size(find(DataMatrix.X(:,i)~=1 & DataMatrix.X(:,i)~=0));
        if (m2==0)
            DataMatrix.X(:,i)=[];
            eliminated = eliminated+1;
        else
            i = i+1;
        end
    end
    DataMatrix.type = 1;
   %....eliminated binary features
   fprintf('\n-----------DONE...Eliminated = %d binary features', eliminated);