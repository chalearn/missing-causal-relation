function value = getproperty(k, property)
%
% GETPROPERTY - get name property of an inhomogenous polynomial kernel
%
%    VALUE = GETPROPERTY(POLYNOMIAL,'PROPERTY') returns the value of the named
%    property of an inhomogenous polynomial kernel.

%
% File        : @polynomial/getproperty.m
%
% Date        : Monday 27th August 2007
%
% Author      : Dr Gavin C. Cawley
%
% Description : Returns the value of a named property of an inhomogenous
%               polynomial kernel. 
%
% History     : 27/08/2007 - v1.00
%
% Copyright   : (c) Dr Gavin C. Cawley, August 2007.
%
%    This program is free software; you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation; either version 2 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program; if not, write to the Free Software
%    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
%  

if nargin ~= 2

   error('wrong number of parameters');

elseif strcmp(property, 'c')

   value = k.c;

elseif strcmp(property, 'd')

   value = k.d;

elseif strcmp(property, 'normalised')

   value = k.normalised;

elseif strcmp(property, 'parameters')

   value = log(k.c)/log(2);

else

   value = getproperty(k.kernel, property);

end

% bye bye...

