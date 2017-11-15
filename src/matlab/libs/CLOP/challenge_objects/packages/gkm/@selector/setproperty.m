function s = setproperty(s, property, value)
%
% SETPROPERTY - set the value of a named property of a selector object
%
%    SELECTOR = SETPROPERTY(SELECTOR,'PROPERTY',VALUE) sets the value of the
%    named property of a model selection object.

%
% File        : @selector/setproperty.m
%
% Date        : Monday 27th August 2007
%
% Author      : Dr Gavin C. Cawley
%
% Description : Set the value of a named property of a model selection object.
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

if strcmp(property, 'estimator')

   s.estimator = value;

elseif strcmp(property, 'type')

   s.type = value;

else

   s.estimator = setproperty(s.estimator, property, value);

   if isempty(s.estimator) & iscell(s.estimator) 

      s = {};

   end

end

% bye bye...

