function [r,a] =  training(a,d)

% Amir R. Saffari, amir@ymer.org , Jan. 2006

if a.algorithm.verbosity>0
    disp(['training ' get_name(a) '.... '])
end

if a.balance
    BalancedSampling    = 1;
else
    BalancedSampling    = 0;
end

YTrain  = get_y(d);
PosNum  = length(find(YTrain == 1));
NegNum  = length(find(YTrain == -1));
PosRat  = PosNum/(PosNum + NegNum);
NegRat  = NegNum/(PosNum + NegNum);
SubF    = a.subratio;
TakeHT  = a.takeHypeTan;
ExampleNum  = length(YTrain);
BERW    = zeros(ExampleNum,1);
BERW(find(YTrain == 1)) = 1 - PosRat;
BERW(find(YTrain == -1)) = 1 - NegRat;
W       = BERW/(sum(BERW));
DoRej   = a.rej;
RejNum  = a.rejNum;

if PosNum >= NegNum
    SExNum  = round(2*NegNum*SubF);
else
    SExNum  = round(2*PosNum*SubF);
end

k   = 0;
rej = 0;

while (k < a.units)&(rej < RejNum)
    cW = cumsum(W);
    
    if BalancedSampling
        SInd = [];
        tic

        SamplingTimeFlag = 1;

        FNumPos = 0;
        FNumNeg = 0;

        while (FNumPos + FNumNeg) <= SExNum
            TempRand = find((cW - rand) >= 0);

            if isempty(SInd)
                SInd = TempRand(1);

                if YTrain(SInd) == 1
                    FNumPos = 1;
                else
                    FNumNeg = 1;
                end
            else
                if sum(ismember(SInd , TempRand(1))) == 0
                    if (FNumPos <= round(SExNum/2))&(YTrain(TempRand(1)) == 1)
                        SInd = [SInd , TempRand(1)];
                        FNumPos = FNumPos + 1;
                    elseif (FNumNeg <= round(SExNum/2))&(YTrain(TempRand(1)) == -1)
                        SInd = [SInd , TempRand(1)];
                        FNumNeg = FNumNeg + 1;
                    end
                end
            end

            SamplingTime = toc;

            if (SamplingTime > 20)&(SamplingTimeFlag == 1)
                disp('Stopped sampling ...')
                cW   = cumsum(ones(1 , ExampleNum)/ExampleNum);
                
                SamplingTimeFlag = 0;
            end
        end
        
        indices = SInd;
    else                    % use standard sampling
        randnum = rand(ExampleNum , 1);
        m       = SExNum;
        indices = zeros(m,1);
        
        for i = 1:m
            %Find which bin the random number falls into
            loc = max(find(randnum(i) > cW));
            if isempty(loc)
                indices(i) = 1;
            else
                indices(i) = loc;
            end
        end
    end

    [r,a.child{k + 1}]  = train(a.child{k + 1},get(d,indices));
    
    E = sum(BERW(indices).*(sign(r.X) ~= r.Y).*W(indices))/sum(BERW(indices).*W(indices));

    if(E > 0.5)&(DoRej)
        rej = rej + 1;
        disp(['Rejected current weak classifier ' , num2str(k + 1) '/' num2str(a.units) , ', weighted error = ' , num2str(E)])
    else       
        disp(['Accepted current weak classifier ' , num2str(k + 1) '/' num2str(a.units) , ', weighted error = ' , num2str(E)])
        if(E == 0)
            E=0.001;
        end
        
        k   = k + 1;
        r   = test(a.child{k} , d);
        if TakeHT
            W   = BERW.*W.*exp(-r.Y.*tanhyp(r.X));
        else
            W   = BERW.*W.*exp(-r.Y.*r.X);
        end
        W   = W./sum(W);
        rej = 0;
    end
end

disp(' ')
disp(['Number of accepted weak classifiers: ' , num2str(k)])
disp(' ')

if k < a.units
    for i = k + 1:a.units        % clear rejected weak classifiers
        a.child{i} = [];
    end
    
    a.units  = k;
end

if ~a.algorithm.do_not_evaluate_training_error
    r   = test(a,d);
else
    r   = set_x(r,get_y(r));
end

% Tangent hyperbolic function
function y = tanhyp(x)

y = 2./(1 + exp(-2*x)) - 1;

return