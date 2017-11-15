function ret =  testing(a,d,loss_type)  



if a.training_method == 0
    %% assumes output of interest is linear
    Yest=[]; 
    
    kern = a.child; kern.calc_on = [1]; % calc joint kernel just on Xsv{1}
    
    K1 = calc(kern, a.Xsv);
    
    if a.output_preimage == 0
        Xst = d.X; Xs=a.Xsv.X; xsv=Xs{1};ysv=Xs{2};a1=a.alpha;
        for i=1:size(Xst{1},1)
            ystar=sum((ysv'*repmat((a1 .* K1(i,:)'),1,size(xsv,2)))',1);
            Yest=[Yest; ystar/norm(ystar)];
        end 
    elseif a.output_preimage == 1
        % output preimage == 1 just calculates the score assigend to each
        % input output pair (x,y)
        kern =a.child;
        K=calc(kern,a.Xsv,d);       % take joint product kernel at the moment
        Yest = K*a.alpha;
    end
    
    
elseif a.training_method == 1
    Yest = test(a.regression_method,d);
    Yest = Yest.X;
end

% Yest = sign(Yest);


% %  Xs=a.Xsv.X; xsv=Xs{1};ysv=Xs{2};a1=a.alpha;
% % if sqrt(prod(size(ysv,2),size(xsv,2)))<1000
% %     % code to calculate W explicitely : can't do this if
% %     % W is of too high dimension (e.g. bag of words?)
% %     global W;    
% %     W=zeros(size(ysv,2),size(xsv,2));
% %     for i=1:length(a1)
% %         W=W+a1(i) * (ysv(i,:)'*xsv(i,:));
% %     end 
% %     W=W/norm(W);
% % end



ret = data(Yest,d.Y);   
ret = set_name(ret,[get_name(d) ' -> ' get_name(a)]);   
