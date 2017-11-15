

function d =  testing(a,d)

yest=[];
for i=1:get_dim(d);
    [r ystar]=argmax(a,a.dtrain,a.alpha,a.svs(:,1),a.svs(:,2),get_x(d,i));
    
    if a.output_preimage==0
        yest=[yest;r];
    else   
        yest=[yest;ystar];
    end
end


d.X=yest; 