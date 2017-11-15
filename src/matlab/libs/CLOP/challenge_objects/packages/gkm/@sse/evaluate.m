function L = evaluate(c, model, y, mu, eta)

% EVALUATE - evaluate the sum-of-squared error
%
%    L = EVALUATE(NLL,MODEL,Y,MU,ETA) evaluate the sum-of-squared error (SSE)
%    for a generalised kernel model, where Y is a column vector of the
%    responses, MU is a column vector describing the model output and ETA is
%    the latent variable.

%
% File        : @sse/evaluate.m
%
% Date        : Friday 24th August 2007
%
% Author      : Dr Gavin C. Cawley
%
% Description : Evaluate the sum-of-squares error metric for performance
%               prediction and model selection.
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

L = 0.5*sum((y-mu).^2);

% bye bye...

