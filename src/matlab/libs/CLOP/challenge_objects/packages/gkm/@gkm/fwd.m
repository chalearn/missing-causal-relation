function [mu,eta] = fwd(net,x)

% FWD - evaluate the output of a generalised kernel machine
%
%    MU = FWD(NET, X) evaluates the output of a generalised kernel machine,
%    NET, for a matrix, X, where each row represents an input pattern and
%    each column represents an attribute.  The output, MU, represents an
%    estimate of the conditional mean of the response distribution.
%
%    [MU,ETA] = FWD(NET,X) also evaluate the sufficient statistic for the
%    response distribution, ETA, i.e. the value of the kernel expansion.
%
%    See also: GKM, TRAIN

%
% File        : @gkm/fwd.m
%
% Date        : Friday 24th August 2007
%
% Author      : Dr Gavin C. Cawley
%
% Description : Compute the output of a generalised kernel machine.
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

K   = evaluate(net.kernel, x, net.x);
eta = K*net.alpha + net.b;
mu  = net.invlink(eta);

% bye bye...

