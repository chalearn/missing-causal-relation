
function a = hadamard_bank(hyper) 
%=============================================================================
% HADAMARD_BANK data object to create a filter bank for the hadamard transform             
%=============================================================================  
% a=hadamard_bank(hyper) 
%
% Generates a "hadamard_bank" object. Adjust the size of the filters by
% "training", i.e. according to the size of the images.
%
%   Hyperparameters
%   dim1                -- size of the match filter
%   dim2
%
%   Data
%   X                   -- matrix of match filters (templates)
%                          Note: the lines are templates and the columns
%                          features. For 2 dimensional templates, the image
%                          is turned into a vector by concatenating its
%                          columns and transposing the vector: m(:)'.
%                          The function "show" restores the 2 dimensional
%                          character of the templates.
%
% Methods:
%  train, test, get_dim, show
%
%=============================================================================
% Author of code: Isabelle Guyon -- isabelle@clopinet.com -- November 2005
%=============================================================================
% <<-------------hyperparameters----------------->> 
a.dim1=default(8,[1, Inf]);
a.dim2=default(8,[1, Inf]);

% <<-------------model----------------->> 

algoType=data('hadamard_bank');
a= class(a,'hadamard_bank',algoType);

eval_hyper;

% Find the closest number larger than the image dimension for which a
% hadamard matrix exists
d1=1; d2=1;
h1=[]; h2=[];
if a.dim1>1
    d1=max(2, min([2^ceil(log2(a.dim1)), 12*2^abs(ceil(log2(a.dim1/12))), 20*2^abs(ceil(log2(a.dim1/20)))]));
    h1=hadamard(d1);
    h1=h1(1:a.dim1,1:a.dim1);
end
if a.dim2>1
    d2=max(2, min([2^ceil(log2(a.dim2)), 12*2^abs(ceil(log2(a.dim2/12))), 20*2^abs(ceil(log2(a.dim2/20)))]));
    h2=hadamard(d2);
    h2=h2(1:a.dim2,1:a.dim2);
end
if isempty(h1)
    a.data.X=h2;
elseif isempty(h2)
    a.data.X=h1;
else
    k=0;
    for i=1:a.dim1
        for j=1:a.dim2
            k=k+1;
            h=h1(:,i)*h2(j,:);
            a.data.X(k,:)=h(:)';
        end
    end
end

        






