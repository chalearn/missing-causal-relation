function value = getproperty(selector, property)

% GETPROPERTY - retrieve property of a simplex optimisation object
%
%    VALUE = GETPROPERTY(SIMPLEX,'PROPERTY') returns the value of the named
%    property of a simplex optimisation object.

%
% File        : @simplex/getproperty.m
%
% Date        : Sunday 26th August 2007
%
% Author      : Dr Gavin C. Cawley
%
% Description : Accessor method used to retrieve properties of a simplex
%               object. 
%
% History     : 26/08/2007 - v1.00
%
% Copyright   : (c) Dr Gavin C. Cawley, August 2007
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

if strcmp(property, 'chi')

  value = selector.chi; 

elseif strcmp(property, 'delta')

   value = selector.delta;

elseif strcmp(property, 'gamma')

   value = selector.gamma;

elseif strcmp(property, 'MaxFunEvals')

   value = selector.MaxFunEvals;

elseif strcmp(property, 'MaxIter')

   value = selector.MaxIter;

elseif strcmp(property, 'rho')

   value = selector.rho;

elseif strcmp(property, 'sigma')

   value = selector.sigma;

elseif strcmp(property, 'TolFun')

   value = selector.TolFun;

elseif strcmp(property, 'TolX')

   value = selector.TolX;

else

   value = getproperty(selector.selector, property);

end

% bye bye...

