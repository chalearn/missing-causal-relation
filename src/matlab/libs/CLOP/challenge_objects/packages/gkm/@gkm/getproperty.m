function value = getproperty(net, property)
%
% GETPROPERTY - get property of a generalised kernel machine
%
%    VALUE = GETPROPERTIES(MODEL,'PROPERTY') returns the value of the named
%    property of a generalised kernel machine object, MODEL.

%
% File        : @gkm/getproperty.m
%
% Date        : Friday 24th August 2007
%
% Author      : Dr Gavin C. Cawley
%
% Descritpion : Return the value of the named property of a generalised kernel
%               machine object.
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

if strcmp(property, 'acronym')

   value = net.acronym;

elseif strcmp(property, 'alpha')

   value = net.alpha;

elseif strcmp(property, 'invlink')

   value = net.invlink;

elseif strcmp(property, 'kernel')

   value = net.kernel;

elseif strcmp(property, 'lambda')

   value = net.lambda;

elseif strcmp(property, 'loss')

   value = net.loss;

elseif strcmp(property, 'MaxIter')

   value = net.MaxIter;

elseif strcmp(property, 'OutputStream')

   value = net.OutputStream;

elseif strcmp(property, 'parameters')

   value = [log(net.lambda)/log(2) ; get(net.kernel, 'parameters')];

elseif strcmp(property, 'theta')

   value = [];

elseif strcmp(property, 'TolFun')

   value = net.TolFun;

elseif strcmp(property, 'W')

   value = net.W;

elseif strcmp(property, 'Verbosity')

   value = net.Verbosity;

else

   value = getproperty(net.kernel, property);

end 

% bye bye...

