function M=browse_digit(X,Y,F)
% M=browse_digit(X,Y,F)
% Browse through a digit database
% X -- Matrix with digits in lines
% Y -- Matrix with labels.
% F -- Array with feature identities.
% x -- Last digit read.
% Isabelle Guyon -- isabelle @ clopinet.com -- May 2005
convert_pix=0;
feat_idx=[];
feat_loc=[];
if nargin>2,
    convert_pix=1;
    kk=0;
    for k=1:length(F)
        ff=F{k};
        if isempty(strfind(ff, 'perm'))&isempty(strfind(ff, 'probe'))&isempty(strfind(ff, 'pair'))
            kk=kk+1;
            dash=strfind(ff, '-');
            ff=ff(dash(end)+1:end);
            feat_idx(kk)=str2num(ff);
            feat_loc(kk)=k;
        end
    end
end

n=1;
p=-1;
e=0;
figure('name', 'Isabelle''s MNIST browser');
num=0;
while 1
    idx = input('Digit number (or n for next, p for previous, e exit)? ');
    if isempty(idx), idx=n; end
    switch idx
    case n
        num=min(num+1,length(Y));
    case p
        num=max(1,num-1);
    case e
        break
    otherwise
        num=idx;
    end
    if convert_pix,
        M=zeros(1,28*28);
        M(feat_idx)=X(num,feat_loc);
    else
        M=X(num,:);
    end
    show_digit(M);
    title(['Index: ' num2str(num) ' Class: ' num2str(Y(num))]);
end