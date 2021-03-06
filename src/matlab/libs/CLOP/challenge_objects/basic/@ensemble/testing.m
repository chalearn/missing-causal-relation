function [d,a] =  testing(a,d)
%[d,a] =  testing(a,d)
% Ensemble testing.

% Isabelle Guyon -- isabelle@clopinet.com -- October 2005/June 2010

% Test all the ensemble members
Res=[];
for i=1:length(a.child)
    r=test(a.child{i},d);
    Res(:,i)=get_x(r);
end

% Optionally take the sign
if a.signed_output
    Res=sign(Res);
end

if 1==2
    nl=0;
    if nl
        % add products of features
        rl=Res;
        for i=1:size(rl,2)
            for j=i+1:size(rl,2)
                Res=[Res rl(:,i).*rl(:,j)];
            end
        end
    end
end

if ~isempty(a.out_model)
    dout=data(Res, get_y(d));
    d=test(a.out_model, dout);
else
    if isempty(a.W)
        a.W=ones(1,size(Res,2));
        a.b0=0;
    end
    % Vote for the final output
    [p, n]=size(Res);
    Yest = Res*a.W' + a.b0(ones(p,1),:);

    % Remove the ties
    zero_val=find(Yest==0);
    Yest(zero_val)=a.algorithm.default_output*eps;

    d=set_x(d,Yest); 
end

if a.algorithm.use_signed_output
    d=set_x(d, sign(get_x(d)));
end
 
d=set_name(d,[get_name(d) ' -> ' get_name(a)]); 
