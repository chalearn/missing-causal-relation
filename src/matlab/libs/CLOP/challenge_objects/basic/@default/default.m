function a = default(defaultvalue, valuerange) 
  

%=============================================================================================
%   DEFAULT default object      
% ============================================================================================
%           a = default(defaultvalue, valuerange)
%
%   This object allows to set default values for hyperparameters.
%   If valuerange is an array with 2 values [min, max], the HP must remain
%   in the range [min, max];
%   If valuerange is an cell array, its items are understood as a list of
%   allowed values (categorical variable.)
%
%   Data members:
%   defaultvalue
%   valuerange
%
%   Methods:
%   get_default, check_range
%=============================================================================================
% Author     : Isabelle Guyon
% Email      : isabelle@clopinet.com
% Date       : September 21, 2005
%=============================================================================================
 
a.defaultvalue=[];
a.valuerange=[];
if nargin>0, a.defaultvalue=defaultvalue; end
if nargin>1, a.valuerange=valuerange; end
  
is_ok=1;
if isempty(a.valuerange)
    is_ok=1;
elseif isnumeric(a.valuerange)
    if length(a.valuerange)==2 
        if a.valuerange(1)>a.valuerange(2)
            is_ok=0;
        end
    else
        is_ok=0;
    end
elseif ~iscell(a.valuerange)
    is_ok=0;
end
if ~is_ok
    error('The value range of a default object must be a [min, max] matrix or a cell array.');
end

a= class(a,'default');

if ~check_range(a, a.defaultvalue)
    error('The default value is not in the defined range.');
end    
  
  




