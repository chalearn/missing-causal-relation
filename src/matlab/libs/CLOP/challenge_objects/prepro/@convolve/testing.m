function dat  =  testing(algo,dat)
%dat =  testing(algo,dat)
% Preprocess with a convolution (2 dimensional square image data assumed).
% Inputs:
% algo -- A "standard" object.
% dat -- A test data object.
% Returns:
% dat -- Preprocessed data.

% Isabelle Guyon -- September 2005 -- isabelle@clopinet.com

X=get_x(dat); 
[p,n]=size(X);

K=get_x(algo.child);
[kp, kn]=size(K);

dn=sqrt(n); % square image dimension
dp=dn;

% Fill with image and convolve
for k=1:p
    % Add border
    M=zeros(dp+2*kp, dn+2*kn);
    % Fill with data
    M(kp+1:kp+dp, kn+1:kn+dn)=reshape(X(k,:),dn,dp);
    % Convolve
    MC=conv2(M, K, 'same');
    % remove border
    x=MC(kp+1:kp+dp, kn+1:kn+dn);
    X(k,:)=x(:);
end

dat=set_x(dat, X);

dat=set_name(dat,[get_name(dat) ' -> ' get_name(algo)]); 
  

 