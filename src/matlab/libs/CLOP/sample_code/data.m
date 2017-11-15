
function data = data(X,Y) 

%========================================================================================================  
% DATA data structure
%========================================================================================================
% Stores data into two components X (input) and Y (output).
% This object (a simple structure) allows you to run the sample code.
% Use rather the spider data object if you are going to run
% more advanced experiments.

% Isabelle Guyon -- isabelle@clopinet.com -- September 2005
  
if nargin>1,
    data.Y=Y;
else
    data.Y=[];
end

data.X=X;
data.sample_code=1;
    
  
