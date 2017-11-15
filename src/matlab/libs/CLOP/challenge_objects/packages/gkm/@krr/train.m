function [net,mu,eta] = train(net, x, y)
%
% TRAIN - train a kernel ridge regression model
%
%    NET=TRAIN(NET,X,Y) trains a kernel ridge regression machine, NET, using
%    the input vectors, X, and responses, Y.
%
%    See also: GKM

%
% File        : @krr/train.m
%
% Date        : Friday 24th August 2007
%
% Author      : Dr Gavin C. Cawley
%
% Description : Train a kernel ridge regression machine.  The toolbox provides
%               an optimsed implementation of the KRR machine, that is much
%               faster than the IRWLS code that would be generated
%               automatically via the MATLAB symbolic math toolbox.
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

% train KRR machine

one     = ones(size(x,1), 1);
K       = evaluate(get(net, 'kernel'), x, x);
R       =  chol(K + diag(get(net, 'lambda')./one));
zeta    = R\(R'\one);
xi      = R\(R'\y);
delta   = 1./sum(zeta);
b       = sum(xi)*delta;
alpha   = xi - zeta*b;

% update GKM model

net = setproperty(net, 'b',     b);
net = setproperty(net, 'alpha', alpha);
net = setproperty(net, 'x',     x);

% optionally perform approximate leave-one-out cross-validation

if nargout > 1

   Ri  = inv(R);
   ci  = sum(Ri.^2,2) - delta*zeta.^2;
   eta = y - alpha./ci;
   mu  = eta;

end

% bye bye...

