function k = kernel(varargin)
%
% KERNEL - abstract base class for all kernel objects

%
% File        : @kernel/kernel.m
%
% Date        : Monday 27th August 2007
%
% Author      : Dr Gavin C. Cawley
%
% Description : Constructor for the abstract base class of all kernel objects.
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

if nargin == 0
   
   % this is the default constructor

   k.type = 'undefined';
   k      = class(k, 'gkm_kernel', object);
   
else

   k = set(gkm_kernel, varargin{:});
   
end

% bye bye...

