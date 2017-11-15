function net = klr(varargin)

% KLR - kernel logistic regression machine machine

%
% File        : @klr/klr.m
%
% Date        : Tuesday 12nd February 2008
%
% Author      : Dr Gavin C. Cawley
%
% Description : Constructor for a kernel logistic regression machine
%               machine.
%
% History     : 12/2/2008 - v1.00
%
% Copyright   : (c) Dr Gavin C. Cawley, February 2008.
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
   net = class(net, 'klr', gkm);
   net = set(net, 'acronym',    'klr', ...
                  'name',       'kernel logistic regression machine', ...
                  'invlink',    inline('exp(eta)./(1+exp(eta))', 'eta'), ...
                  'loss',       inline('-(y.*eta - log(1+exp(eta)))', 'y', 'eta', 'mu', 'theta'), ...
                  'W',          inline('exp(eta)./(1+exp(eta)).^2', 'eta'), ...
                  'canonical',  'log(1+exp(eta))');

else

   net = set(klr, varargin{:});
   
end

% bye bye...

