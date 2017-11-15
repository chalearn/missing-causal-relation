function s = simplex(varargin)
%
% SIMPLEX - Nelder-Mead simplex procedure for model selection
%
%    S = SIMPLEX creates a new model selection object for tuning the 
%    hyper-parameters of a generalised kernel machines using the Nelder-Mead
%    simplex optimisation procedure [1].
%
%    S = SIMPLEX('ESTIMATOR',SPLITSAMPLE) specifies that a split-sample
%    estimator is to be used for model selection in place of the default
%    approximate leave-one-out cross-validation estimator (ALOO).
%
%    S = SIMPLEX('PARAMETER',VALUE,...) optionally initialised the values
%    of one or more optimisation parameters, specified by a sequence of
%    name-value pairs.  The following optimisation parameters are available:
%
%       Chi         - Parameter governing expansion steps
%       Delta       - Parameter governing size of initial simplex.
%       Gamma       - Parameter governing contraction steps.
%       Rho         - Parameter governing reflection steps.
%       Sigma       - Parameter governing shrinkage steps.
%       MaxIter     - Maximum number of optimisation steps.
%       MaxFunEvals - Maximum number of function evaluations.
%       TolFun      - Stopping criterion based on the relative change in
%                     value of the function in each step.
%       TolX        - Stopping criterion based on the change in the
%                     minimiser in each step.
%
%   The default values for these optimisation parameters are as follows:
%
%       Chi         = 2
%       Delta       = 0.01
%       Gamma       = 0.5
%       Rho         = 1
%       Sigma       = 0.5
%       MaxIter     = 200
%       MaxFunEvals = 1000
%       TolFun      = 1e-6
%       TolX        = 1e-6
%
%    References:
%
%       [1] J. A. Nelder and R. Mead, "A simplex method for function
%           minimization", Computer Journal, 7:308-313, 1965.
%
%    See also: SELECTOR/SELECT, ESTIMATOR

%
% File        : @simplex/simplex.m
%
% Date        : Sunday 26th August 2007
%
% Author      : Dr Gavin C. Cawley
%
% Description : Implementation of the Nelder-Mead simplex algortihm for
%               tuning the hyper-parameters of a generalised kernel machine.
%
% References  : [1] J. A. Nelder and R. Mead, "A simplex method for function
%                   minimization", Computer Journal, 7:308-313, 1965.
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

   s.chi         = 2;
   s.delta       = 0.01;
   s.gamma       = 0.5;
   s.rho         = 1;
   s.sigma       = 0.5;
   s.MaxIter     = 200;
   s.MaxFunEvals = 1000;
   s.TolFun      = 1e-6;
   s.TolX        = 1e-6;
   s             = class(s, 'simplex', selector('type', 'Nelder-Mead simplex'));

else

   s = set(simplex, varargin{:});
   
end

% bye bye...

