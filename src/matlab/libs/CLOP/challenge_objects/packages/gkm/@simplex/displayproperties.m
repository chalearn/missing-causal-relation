function displayproperties(s)
%
% DISPLAYPROPERTIES - display modifiable properties of a simplex object

%
% File        : @simplex/displayproperties.m
%
% Date        : Sunday 26th August 2007
%
% Author      : Dr Gavin C. Cawley
%
% Description : Display the modifiable properties of a simplex optimiser object
%               used in model selection for generalised kernel machines.
%
% History     : 26/08/2007 - v1.00
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

displayproperties(s.selector);
fprintf(1, '   rho          = %f\n', s.rho);
fprintf(1, '   chi          = %f\n', s.chi);
fprintf(1, '   gamma        = %f\n', s.gamma);
fprintf(1, '   sigma        = %f\n', s.sigma);
fprintf(1, '   delta        = %f\n', s.delta);
fprintf(1, '   MaxFunEvals  = %d\n', s.MaxFunEvals);
fprintf(1, '   MaxIter      = %d\n', s.MaxIter);
fprintf(1, '   TolFun       = %f\n', s.TolFun);
fprintf(1, '   TolX         = %f\n', s.TolX);

% bye bye...

