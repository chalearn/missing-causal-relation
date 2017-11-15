function net = setproperty(net, property, value)
%
% SETPROPERTY - set named property of a generalised kernel machine
%
%    MODEL = SETPROPERTY(MODEL,'PROPERY',VALUE) sets the value of the
%    named property of a generalised kernel machine, MODEL.

%
% File        : @gkm/setproperty.m
%
% Date        : Monday 27th August 2007
%
% Author      : Dr Gavin C. Cawley
%
% Description : Set the value of a named property of a generalised kernel
%               machine.
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

   if ischar(value)

      net.acronym = value;

   end

elseif strcmp(property, 'alpha')

   net.alpha = value;

elseif strcmp(property, 'b')

   net.b = value;

elseif strcmp(property, 'canonical')

   net.canonical = value;

   if ischar(net.invlink)

      syms('eta');

      str         = char(simplify(diff(net.canonical)));
      str         = regexprep(str, '\*', '\.*');
      str         = regexprep(str, '/',  './');
      str         = regexprep(str, '\^', '.\^');
      net.invlink = inline(str, 'eta');

      % set up loss function

      str      = ['-(y*eta - ' char(net.canonical) ')'];
      str      = regexprep(str, '\*', '\.*');
      str      = regexprep(str, '/',  './');
      str      = regexprep(str, '\^', '.\^');
      net.loss = inline(str, 'y', 'eta', 'mu', 'theta');

      % set up weight function for IRWLS training

      str   = char(simplify(diff(net.canonical, 2)));
      str   = regexprep(str, '\*', '\.*');
      str   = regexprep(str, '/',  './');
      str   = regexprep(str, '\^', '.\^');
      net.W = inline(str, 'eta');

      % check to see if W is constant

      W = net.W([0;0]);

      if isscalar(W)

         net.W = inline(['(' str ')*ones(size(eta))']);

      end

   end

elseif strcmp(property, 'invlink')

   net.invlink = value;

elseif strcmp(property, 'loss')

   net.loss = value;

elseif strcmp(property, 'W')

   net.W = value;

elseif strcmp(property, 'kernel')

   net.kernel = value;

elseif strcmp(property, 'lambda')

   net.lambda = value(:);

elseif strcmp(property, 'name')

   net.name = value;

elseif strcmp(property, 'Verbosity')

   net.Verbosity = value;

elseif strcmp(property, 'parameters')

   net.lambda = max(2^value(1), 1e-9);
   net.kernel = set(net.kernel, 'parameters', value(2:end));

elseif strcmp(property, 'x')

   net.x = value;

else

   net = {};

end

% bye bye...

