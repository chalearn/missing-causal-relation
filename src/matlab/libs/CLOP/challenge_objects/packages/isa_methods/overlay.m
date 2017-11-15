function [score, alpha, sdigit2]=overlay(digit1, digit2)
%[score, alpha, sdigit2]=overlay(digit1, digit2)
% Find best match of digit 2 on digit 1

% Isabelle Guyon -- isabelle@clopinet.com -- June 2004

angle=-pi/3:pi/60:pi/3;
s=zeros(size(angle));
for k=1:length(angle)
    alpha=angle(k);
    sdigit2=skew(digit2, alpha);
    s(k)=sum(sum(digit1.*sdigit2))./(sqrt(sum(sum(sdigit2.*sdigit2))));
end
[score,si]=max(s);
score=score./sqrt(sum(sum(digit1.*digit1)));
alpha=angle(si);
sdigit2=skew(digit2, alpha);

return