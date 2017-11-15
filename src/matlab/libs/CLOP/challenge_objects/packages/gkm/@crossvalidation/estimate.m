function [L, e] = estimate(e,model,x,y,varargin)
%
% ESTIMATE - estimate k-fold cross-validation performance criterion
%
%    L = ESTIMATE(CROSSVALIDATION,MODEL,X,Y) estimates the k-fold cross-
%    validation estimate of a performance criterion, for data (X,Y).

%
% File        : @crossvalidation/estimate.m
%
% Date        : Friday 24th August 2007
%
% Author      : Dr Gavin C. Cawley
%
% Description : Evaluate the k-fold cross-validation estimate of a performance
%               criterion for model selection and/or performance prediction
%               using the generalised kernel machine.
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

ntp = size(x, 1);

if e.k < 2

   k = ntp;

elseif e.k > ntp

   k = ntp;

else

   k = e.k;

end

criterion = get(e, 'criterion');
partition = mod(1:ntp, k) + 1;

for i=1:k

   % form training and test sets

   idx_train = find(partition ~= i);
   idx_test  = find(partition == i);

   % train model

   m = train(model, x(idx_train,:), y(idx_train), varargin{:});

   % evaluate predictions for the unused partition

   [mu,eta] = fwd(m, x(idx_test,:));

   % evaluate model performance criterion

   L(i) = evaluate(criterion, model, y(idx_test), mu, eta);

end

L = mean(L);

% bye bye...

