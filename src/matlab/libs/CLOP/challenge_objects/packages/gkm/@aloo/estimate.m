function [L, e] = estimate(e,model,x,y,varargin)
%
% ESTIMATE - estimate approximate leave-one-out negative log-likelihood
%
%    L = ESTIMATE(ALOO,MODEL,X,Y) computes an approximate leave-one-out
%    cross-validation estimate of the negative log-likelihood for a 
%    generalised kernel MODEL, for training data (X, Y).
%
% See also: @gkm/train

%
% File        : @aloo/estimate.m
%
% Date        : Friday 24th August 2007
%
% Author      : Dr Gavin C. Cawley
%
% Description : Compute an approximate leave-one-out cross-validation of the
%               negative log-likelihood for use in model selection of the
%               generalised kernel machine.
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

[model, mu, eta] = train(model, x, y, varargin{:});

L = evaluate(getproperty(e.estimator, 'criterion'), model, y, mu, eta);

% bye bye...

