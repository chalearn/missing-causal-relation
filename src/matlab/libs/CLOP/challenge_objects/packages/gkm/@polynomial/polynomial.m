function k = polynomial(varargin)
%
% POLYNOMIAL - inhomogenous polynomial kernel
%
%    POLYNOMIAL is a class implementing simple inhomogenous polynomial
%    kernel functions, given by
%
%       K(x1, x2) = (x1*x2' + c).^d;
%
%    where d is a parameter controling the order of the polynomial feature
%    space and c is a parameter controling the relative importance of high-
%    and low-order features.
%
%    K = POLYNOMIAL creates a default quadratic kernel (d = 2, c = 1).
%
%    K = POLYNOMIAL('D',3,'C',0) allows the order and weighting factor
%    to be specified, in this case creating an homogenous cubic kernel.
%
%    K = POLYNOMIAL('NORMALISED',true) specifies a normalised polynomial
%    kernel.

%
% File        : @polynomial/polynomial.m
%
% Date        : Wednesday 20th December 2000 
%
% Author      : Dr Gavin C. Cawley
%
% Description : Constructor for a class implementing inhomogenoud polynomial
%               kernels.
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
   
   k.c          = 1;
   k.d          = 2;
   k.normalised = false;
   k            = class(k, 'polynomial', gkm_kernel('type', 'polynomial'));
   
else

   k = set(polynomial, varargin{:});

end

% bye bye...

