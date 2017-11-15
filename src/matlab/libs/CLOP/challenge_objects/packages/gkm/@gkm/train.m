function [net,mu,eta,grad] = train(net, x, y, varargin)
%
% TRAIN - train a generalised kernel machine via IRWLS
%
%    MODEL=TRAIN(MODEL,X,Y) trains a generalised kernel machine, MODEL, using
%    the input vectors, X, and responses, Y.  Here X is typically a matrix
%    containing the input vectors, where each row represents a training
%    pattern and each column an input feaure and Y is a column vector 
%    containing the corresponding values for the response variable.
%
%    See also: GKM

%
% File        : @gkm/train.m
%
% Date        : Mondel 27t August 2007
%
% Author      : Dr Gavin C. Cawley
%
% Description : Train a generalised kernel machine using Newtons' method.
%
% History     : 27/08/2007 - v1.00 
%
% Copyright   : (c) Dr Gavin C. Cawley, April 2007.
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

% set up reporting format

format = 'epoch = %3d : L = %+-12.10g   ';

if strcmp(net.Verbosity, 'ethereal')

   report = @ethereal;

elseif strcmp(net.Verbosity, 'silent')

   report = @silent;

elseif strcmp(net.Verbosity, 'verbose')

   report = @verbose;

end

% initialisation

[ntp,d] = size(x);
alpha   = zeros(ntp, 1);
one     = ones(ntp, 1);
K       = evaluate(net.kernel, x, x);
eta     = zeros(ntp, 1);
mu      = net.invlink(eta);
L       = sum(net.loss(y,eta,mu,net.theta));

report(net.OutputStream, format, 0, L);

% get on with it!

for i=1:net.MaxIter

   w     = max(net.W(eta), 1e-6);
   z     = eta + (y - mu)./w;
   R     = chol(K + diag(net.lambda./w));
   zeta  = R\(R'\one);
   xi    = R\(R'\z);
   delta = 1./sum(zeta);
   b     = sum(xi)*delta;
   alpha = xi - zeta*b;
   eta   = K*alpha + b;
   mu    = net.invlink(eta);
   L_new = sum(net.loss(y,eta,mu,net.theta)) + 0.5*net.lambda*alpha'*K*alpha;

   report(net.OutputStream, format, i, L_new);

   if abs(L_new - L) < net.TolFun

      break;

   end

   L = L_new;

end

report(1);

net.alpha = alpha;
net.b     = b;
net.x     = x;

if nargout > 1

   % compute an approximate leave-one-out estimate of the loss

   Ri  = inv(R);
   ci  = sum(Ri.^2,2) - delta*zeta.^2;
   eta = z - alpha./ci;
   mu  = net.invlink(eta);

   if nargout > 3

      % compute the gradient information

   end

end

function ethereal(fd, format, varargin)

backspace = char(8);

if nargin > 1

   str = sprintf(format, varargin{:});

else

   str = repmat(' ', 79, 1);

end

fprintf(fd, '%s%s', str, repmat(backspace, size(str)));

function verbose(fd, format, varargin)

if nargin > 1

   fprintf(fd, [format '\n'], varargin{:});

end

function silent(fd, format, varargin)

% bye bye...

