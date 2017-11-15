function d =  testing(a,d)

% Amir R. Saffari, amir@ymer.org, Jan. 2006

[n c]= size(get_y(d));

if (n == 0)|(c == 0)
    
    [n c]   = size(get_x(d));
    c       = 1;
    
end

r       = zeros(n, c);
TakeHT  = a.takeHypeTan;
for i=1:a.units
    if TakeHT
        r =  r + tanhyp(get_x(test(a.child{i},d)));
    else
        r =  r + get_x(test(a.child{i},d));
    end
end

if a.algorithm.use_signed_output
    r   = sign(r);
end

if(c > 1)
    L=-ones(c)+2*eye(c);
    for i=1:n
        [mi ind]=min(sum(abs(repmat(r(i,:),c,1)-L),2));
        r(i,:)=L(ind,:);
    end
end

d   = set_x(d,r);
d   = set_name(d,[get_name(d) ' -> ' get_name(a)]);

% Tangent hyperbolic function
function y = tanhyp(x)

y = 2./(1 + exp(-2*x)) - 1;

return