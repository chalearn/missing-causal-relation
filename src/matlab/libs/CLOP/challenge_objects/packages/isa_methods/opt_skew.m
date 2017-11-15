function alpha=opt_skew(digit)
%alpha==opt_skew(digit)
% Find approximately the angle the deskews best

% Isabelle Guyon -- isabelle@clopinet.com -- June 2004

angle=-pi/6:pi/60:pi/6;
s=zeros(size(angle));
for k=1:length(angle)
    alpha=angle(k);
    sdigit=skew(digit, alpha);
    s(k)=support(sdigit);
end
[m,mi]=min(s);
alpha=angle(mi);