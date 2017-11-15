function value = getproperty(e, property)
%
% GETPROPERTY - get cross-validation estimator properties 
%
%    VALUE = GETPROPERTIES(CROSSVALIDATION,'PROPERTY') returns the value of
%    the named property of a cross-validation performance estimation object.

%
% File        : @crossvalidation/getproperty.m
%
% Date        : Friday 24th August 2007
%
% Author      : Dr Gavin C. Cawley
%
% Descritpion : Return the value of the named property of a crossvalidation
%               performance estimation object.
%
% History     : 24/08/2007 - v.100
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

if strcmp(property, 'k')

   value = e.k;

else

   value = getproperty(e.estimator, property);

end 

% bye bye...

