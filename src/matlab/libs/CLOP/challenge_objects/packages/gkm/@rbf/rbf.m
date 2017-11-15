function k = rbf(varargin)
%
% RBF - Gaussian radial basis function (RBF) kernel

%
% File        : @rbf/rbf.m
%
% Date        : Monday 27th August 2007 
%
% Author      : Dr Gavin C. Cawley
%
% Description : Constructor for a class implementing the Gaussian redial
%               basis function kernel.
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
   
   k.eta = 1;
   k     = class(k, 'rbf', gkm_kernel('type', 'Gaussian radial basis function'));
   
else

   k = set(rbf, varargin{:});

end

% bye bye...

