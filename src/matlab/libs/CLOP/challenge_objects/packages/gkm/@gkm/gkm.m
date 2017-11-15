function net = gkm(varargin)
%
% GKM - Generalised kernel machine
%
%    This is the constructor for a class implementing the generalised kernel
%    machine.  Generally GKM will not be used directly, but instead a
%    concrete subclass will be used, often generated using the FIX method.
%    Here we will give an example based on kernel logistic regression.  First
%    we need to specify the canonical function, defining the Bernoulli loss
%    as a member of the exponetial family of distributions
%
%       NET=GKM('CANONICAL','LOG(1+EXP(ETA))');
%
%    If the MATLAB symbolic math toolbox is installed, the neccesary code
%    implementing this specific form of generalised kernel machine will 
%    auomatically be generated.  Otherwise, we need to specify a couple of 
%    inline functions manually (see [1] for details):
%
%       NET=SET(NET,'INVLINK',INLINE('EXP(ETA)./(1+EXP(ETA))','ETA'), ...
%          'LOSS',INLINE('-(Y.*ETA-LOG(1+EXP(ETA)))','Y','ETA'), ...
%          'W',INLINE('EXP(ETA)./(1+EXP(ETA)).^2', 'ETA'),
%
%    These inline functions represent the inverse of the link function, the
%    negative log-likelihood and the weight function used by the iteratively
%    reweighted least squares (IRWLS) training procedure. 
%    
%    References:
%
%    [1] Cawley, G. C., Janacek, G. J. and Talbot, N. L. C., "Generalised
%        kernel machines", Proceedings of the IEEE/INNS International Joint 
%        Conference on Neural Networks (IJCNN'07), Orlando, Florida, USA,
%        August 12-17, 2007.
%
%    See also: GKM/FIX

%
% File        : @gkm/gkm.m
%
% Date        : Friday 24th August 2007
%
% Author      : Dr Gavin C. Cawley
%
% Description : Constructor for a class implementing a family of generalised
%               kernel machines.  
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
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program; if not, write to the Free Software
%    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
%

if nargin == 0

   net.name         = 'generalised kernel machine';
   net.acronym      = 'gkm';
   net.canonical    = 'undefined';
   net.invlink      = 'undefined';
   net.loss         = 'undefined';
   net.W            = 'undefined';
   net.kernel       = rbf;
   net.lambda       = 1e-6;
   net.theta        = [];
   net.alpha        = [];
   net.b            = 0;
   net.x            = []; 
   net.TolFun       = 1e-9;
   net.MaxIter      = 20;
   net.MaxHalvings  = 10;
   net.Verbosity    = 'verbose';
   net.OutputStream = 1;
   net              = class(net, 'gkm', object);

else

   net = set(gkm, varargin{:});
   
end

% bye bye...

