function selector = setproperty(selector, property, value)
%
% SETPROPERTY - set the value of a namad eproperty of a simplex optimiser
%
%    SIMPLEX = SETPROPERTY(SIMPLEX,'PROPERTY',VALUE) sets the value of
%    the named property of a simplex model selection object.

%
% File        : @simplex/setproperty.m
%
% Date        : Monday 27th August 2007
%
% Author      : Dr Gavin C. Cawley
%
% Description : Set a named property of a Nelder-Mead simplex model selection
%               object.
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

if strcmp(property, 'chi')

  selector.chi = value;; 

elseif strcmp(property, 'delta')

   selector.delta = value;

elseif strcmp(property, 'gamma')

   selector.gamma = value;

elseif strcmp(property, 'MaxFunEvals')

   selector.MaxFunEvals = value;

elseif strcmp(property, 'MaxIter')

   selector.MaxIter = value;

elseif strcmp(property, 'rho')

   selector.rho = value;

elseif strcmp(property, 'sigma')

   selector.sigma = value;

elseif strcmp(property, 'TolFun')

   selector.TolFun = value;

elseif strcmp(property, 'TolX')

   selector.TolX = value;

else

   s = setproperty(selector.selector, property, value);

   if isempty(s) & iscell(s)

      selector = {};

   else

      selector.selector = s;

   end

end

% bye bye...

