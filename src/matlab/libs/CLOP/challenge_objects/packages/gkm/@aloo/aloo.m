function e = crossvalidation(varargin)
%
% ALOO - approximate leave-one-out cross-validation estimator
%
%    E = ALOO creates a performance estimation object for model selection
%    purposes, based on an approximate leave-one-out cross-validation
%    procedure.  The default criterion is the negative log-likelihood.
%
%    E = ALOO('CRITERION',C) creates an aproximate leave-one-out estimator
%    for a user-specified criterion C.
%
% See also: @GKM/TRAIN, CRITERION

%
% File        : @aloo/aloo.m
%
% Date        : Friday 24th August 2007
%
% Author      : Dr Gavin C. Cawley
%
% Description : Constructor for @aloo, a class used to implement model
%               selection via an approximate leave-one-out cross-validation 
%               estimate of the negative log-likelihood.
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
   
   e = class(struct([]), 'aloo', estimator('type','approximate leave-one-out'));
   
else

   % set all parameters

   e = set(aloo, varargin{:});

end

% bye bye...

