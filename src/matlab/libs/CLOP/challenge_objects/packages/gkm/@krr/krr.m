function net = krr(varargin)
%
% KRR - kernel ridge regression machine
%
%    MODEL = KRR('KERNEL',RBF,'LAMBDA',1) creates a kernel ridge regression 
%    machine, optionally specifying a Gaussian redial basis function kernel
%    and an initial value for the regularisation parameters, LAMNDA.
%
%    The toolbox provides a concrete implementation of the KRR machine as the
%    code automatically generated using the symbolic math toolbox would be
%    substantially inefficient.
%
%    See alse: GKM

%
% File        : @krr/krr.m
%
% Date        : Sunday 26th August 2007
%
% Author      : Dr Gavin C. Cawley
%
% Description : Constructor for a class implementing the  kernel ridge
%               regression (KRR) machine.
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

if nargin == 0

   net = struct([]);
   net = class(net, 'krr', gkm);
   net = set(net, 'acronym',    'krr', ...
            'name',       'kernel ridge regression machine', ...
            'invlink',    inline('eta', 'eta'), ...
            'loss',       inline('-(y.*eta - 0.5.*eta.^2)', 'y', 'mu', 'eta', 'theta'), ...
            'W',          inline('(1.)*ones(size(eta))', 'eta'), ...
            'canonical',  '0.5*eta^2');

else

   net = set(krr, varargin{:});
   
end

% bye bye...

