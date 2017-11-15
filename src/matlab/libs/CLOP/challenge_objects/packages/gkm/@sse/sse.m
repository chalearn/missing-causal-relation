function c = sse(varargin)
%
% SSE - sum-of-squared errors metric for performance evaluation

%
% File        : @sse/sse.m
%
% Date        : Sunday 26th August 2007
%
% Author      : Dr Gavin C. Cawley
%
% Description : Constructor for a class implementing the sum-of-squared errors
%               for performance evaluation and model selection for generalised
%               kernel machines.
%
% History     : 26/08/2007 - v1.0
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
   
   c = class(struct([]), 'sse', criterion('type', 'sum-of-squares'));
   
else

   % set all parameters

   c = set(sse, varargin{:});

end

% bye bye...

