function k = setproperty(k, property, value)

% SETPROPERTY - set the value of a named property of a Gaussian RBF kernel
%
%    K = SETPROPERTY(RBF,'PROPERTY',VALUE) sets the value of the named
%    property of a Gaussian radial basis function kernel.

%
% File        : @rbf/setproperty.m
%
% Date        : Monday 27th August 2007
%
% Author      : Dr Gavin C. Cawley
%
% Description : Set the value of the named property of a Gaussian radial basis
%               function kernel object.
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

if strcmp(property, 'eta')

   k.eta = value;

elseif strcmp(property, 'parameters')

   k.eta = 2.^value(:);

else

   % attempt to set property of parent class

   K = setproperty(k.kernel, property, value);

   if isempty(K) & iscell(K)

      k = {};

   else

      k.kernel = K;
 
   end

end 

% bye bye...

