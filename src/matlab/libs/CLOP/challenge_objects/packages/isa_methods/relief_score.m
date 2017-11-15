function XR=relief_score(X, nearest_hits, nearest_misses, alpha)
%XR=relief_score(X, nearest_hits, nearest_misses, alpha)
% Compute the Relief score, for each image, that is also 
% an image of same size.

XR=zeros(size(X));
p=size(X,1);
n=size(nearest_hits,2);
for k=1:p
%k=round(rand*100);
    Num=0;
    Den=0;
    digit1=reshape_digit(X(k,:));
    q=size(digit1,1);
    M=zeros(2*q);
    M(1:q,1:q)=inormalize(digit1);
    for i=1:n
        h=nearest_hits(k,i);
        m=nearest_misses(k,i);
        digit2=skew(reshape_digit(X(h,:)),alpha(k,h));
        %figure; show_digit(digit2); title('digit2');
        digit3=skew(reshape_digit(X(m,:)),alpha(k,m));
        %figure; show_digit(digit3); title('digit3');
        num=abs(digit1-digit3); 
        %figure; show_digit(num); title('num');
        den=abs(digit1-digit2);
        %figure; show_digit(den); title('den');
        Num=Num+num;
        Den=Den+den;
    end
    M(1:q, q+1:2*q)=inormalize(Num);
    M(q+1:2*q, 1:q)=inormalize(Den);
    Den=Den+mean(mean(Den));
    rdigit=Num./Den;
    M(q+1:2*q, q+1:2*q)=inormalize(rdigit);
    %figure; show_digit(M); 
    XR(k,:)=deshape_digit(rdigit);
end

return
