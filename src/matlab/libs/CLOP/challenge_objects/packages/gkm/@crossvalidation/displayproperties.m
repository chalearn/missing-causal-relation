function displayproperties(e)
%
% DISPLAYPROPERTIES - display cross-validation properties

%
% File        : @crossvalidation/displayproperties.m
%
% Date        : Friday 24th August 2007
%
% Author      : Dr Gavin C. Cawley
%
% Description : Display the modifiable properties of a crossvalidation
%               performance estimator object.
%
% History     : 24/07/2007 - v1.00
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

displayproperties(e.estimator);
fprintf(1, '   k            = %s\n', mat2str(e.k));

% bye bye...

