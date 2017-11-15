function e = crossvalidation(varargin)
%
% CROSSVALIDATION - k-fold cross-validation estimator
%
%    E = CROSSVALIDATION creates a performance estimation object for model
%    selection and performance estimation purposes, based on 5-fold cross-
%    validation.  The default criterion is the negative log-likelihood.
%
%    E = CROSSVALIDATION('K',K) creates an estimator based on K-fold
%    cross-validation.  If K is less than 2 or greater than or equal to the
%    number of patterns, leave-one-out cross-validation will be used.
%
%    E = CROSSVALIDATION('CRITERION',C) optionally allows an alternative
%    performance criterion, C, to be specified.
%
% See also: CRITERION

%
% File        : @crossvalidation/crossvalidation.m
%
% Date        : Friday 24th August 2007
%
% Author      : Dr Gavin C. Cawley
%
% Description : Constructor for a class implementing
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
   
   % this is the default constructor
   
   e.k = 5;
   e   = class(e, 'crossvalidation', ... 
            estimator('type', 'k-fold cross-validation'));
   
else

   % set all parameters

   e = set(crossvalidation, varargin{:});

end

% bye bye...

