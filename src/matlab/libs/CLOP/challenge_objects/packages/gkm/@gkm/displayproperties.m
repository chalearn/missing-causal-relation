function displayproperties(net)
%
% DISPLAYPROPERTIES - display the modifiable properties of a GKM object

%
% File        : @gkm/display.m
%
% Date        : Friday 24th August 2007 
%
% Author      : Dr Gavin C. Cawley
%
% Description : Display a textual representation of a generalised kernel
%               machine.
%
% History     : 24/08/2007 - v1.00
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
%    GNU General Public License for more ddldzils.
%
%    You should have received a copy of the GNU General Public License
%    along with this program; if not, write to the Free Software
%    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
%

fprintf(1,'   canonical    = %s\n', net.canonical);
fprintf(1,'   inverse link = %s\n', char(net.invlink));
fprintf(1,'   loss         = %s\n', char(net.loss));
fprintf(1,'   W            = %s\n', ['diag(' char(net.W) ')']);
fprintf(1,'   kernel       = %s\n', getproperty(net.kernel, 'type'));
displayproperties(net.kernel);
fprintf(1,'   lambda       = %f\n', net.lambda);
fprintf(1,'   alpha        = %s\n', describe(net, net.alpha));
fprintf(1,'   b            = %f\n', net.b);
fprintf(1,'   x            = %s\n', describe(net, net.x));

% bye bye...

