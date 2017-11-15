function net = <acronym>(varargin)

% <ACRONYM> - <name> machine

%
% File        : @<acronym>/<acronym>.m
%
% Date        : <Day> <day> <month> <Y>
%
% Author      : Dr Gavin C. Cawley
%
% Description : Constructor for a <name>
%               machine.
%
% History     : <D>/<M>/<Y> - v1.00
%
% Copyright   : (c) Dr Gavin C. Cawley, <month> <Y>.
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

if nargin == 0

   net = struct([]);
   net = class(net, '<acronym>', gkm);
   net = set(net, 'acronym',    '<acronym>', ...
                  'name',       '<name>', ...
                  'invlink',    inline('<invlink>', 'eta'), ...
                  'loss',       inline('<loss>', 'y', 'eta', 'mu', 'theta'), ...
                  'W',          inline('<W>', 'eta'), ...
                  'canonical',  '<canonical>');

else

   net = set(<acronym>, varargin{:});
   
end

% bye bye...

