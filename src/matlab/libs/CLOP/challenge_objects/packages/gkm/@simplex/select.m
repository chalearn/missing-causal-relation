function [model, P, F] = select(s, model, x, t, varargin)
%
% SELECT - perform model selection via the Nelder-Mead simplex procedure
%
%    MODEL = SELECT(SIMPLEX,MODEL,X,Y) optimised the hyper-parameters of a
%    generalised kernel machine, MODEL, using a the Nelder-Mead SIMPLEX [1]
%    optimisation algorithm.
%
%    References:
%
%    [1] J. A. Nelder and R. Mead, "A simplex method for function
%        minimization", Computer Journal, 7:308-313, 1965.

%
% File        : @simplex/select.m
%
% Date        : Sunday 26th August 2007
%
% Author      : Dr Gavin C. Cawley
%
% Description : Select the optimal hyper-parameters for a generalised kernel
%               machine optimisation of a model selection criterion using the
%               Nelder-Mead simplex procedure [1].
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

% get info

estimator = get(s, 'estimator');

% get initial parameters

P  = get(model, 'parameters');
np = length(P);
p  = repmat(P', np+1, 1);
f  = zeros(np+1, 1);

% form initial simplex

for i=1:np

   p(i,i) = p(i,i) + s.delta;   
   model = set(model, 'parameters', p(i,:));
   f(i)   = estimate(estimator, model, x, t, varargin{:});

end

model   = set(model, 'parameters', p(np+1,:));
f(np+1) = estimate(estimator, model, x, t, varargin{:});

P = p;
F = f;

count = np+1;

format = '  % 4d        % 4d     % 12f     %s\n';
fprintf(1, '\n Iteration   Func-count    min f(x)    Procedure\n\n');
fprintf(1, format, 1, count, min(f), 'initial');


% iterative improvement

for i=2:s.MaxIter

   % order

   [f,idx] = sort(f);
   p       = p(idx,:);

   % reflect

   centroid = mean(p(1:end-1,:));
   p_r      = centroid + s.rho*(centroid - p(end,:));
   model    = set(model, 'parameters', p_r);
   f_r      = estimate(estimator, model, x, t, varargin{:});
   count    = count + 1;
   P        = [P ; p_r];
   F        = [F ; f_r];

   if f_r >= f(1) & f_r < f(end-1)

      % accept reflection point

      p(end,:) = p_r;
      f(end)   = f_r;
      fprintf(1, format, i, count, min(f), 'reflect');

   else

      if f_r < f(1)

         % expand

         p_e   = centroid + s.chi*(p_r - centroid);
         model = set(model, 'parameters', p_e);
         f_e   = estimate(estimator, model, x, t, varargin{:});
         count = count + 1;
         P     = [P ; p_e];
         F     = [F ; f_e];

         if f_e < f_r

            % accept expansion point

            p(end,:) = p_e;
            f(end)   = f_e;
            fprintf(1, format, i, count, min(f), 'expand');

         else

            % accept reflection point

            p(end,:) = p_r;
            f(end)   = f_r;
            fprintf(1, format, i, count, min(f), 'reflect');

         end

      else 

         % contract

         shrink = 0;

         if f(end-1) <= f_r & f_r < f(end)

            % contract outside

            p_c = centroid + s.gamma*(p_r - centroid);
            model = set(model, 'parameters', p_c);
            f_c   = estimate(estimator, model, x, t, varargin{:});
            count = count + 1;
            P     = [P ; p_c];
            F     = [F ; f_c];

            if f_c <= f_r
            
               % accept contraction point

               p(end,:) = p_c;
               f(end)   = f_c;
               fprintf(1, format, i, count, min(f), 'contract outside');

            else

               shrink = 1;

            end

         else

            % contract inside

            p_c = centroid + s.gamma*(centroid - p(end,:));
            model = set(model, 'parameters', p_c);
            f_c   = estimate(estimator, model, x, t, varargin{:});
            count = count + 1;
            P     = [P ; p_c];
            F     = [F ; f_c];

            if f_c <= f(end)
            
               % accept contraction point

               p(end,:) = p_c;
               f(end)   = f_c;
               fprintf(1, format, i, count, min(f), 'contract inside');

            else

               shrink = 1;

            end

         end

         if shrink
         
            % shrink

            for j=2:np+1

               p(j,:) = p(1,:) + s.sigma*(p(j,:) - p(1,:));
               model  = set(model, 'parameters', p(j,:));
               f(j)   = estimate(estimator, model, x, t, varargin{:});
               count  = count + 1;
               P     = [P ; p(j,:)];
               F     = [F ; f(j)];

            end

            fprintf(1, format, i, count, min(f), 'shrink');

         end

      end

   end

   % evaluate stopping criterion

   if max(abs((min(p) - max(p)))./max(abs(p))) < s.TolX

      fprintf(1, 'optimisation terminated sucessfully (TolX criterion)\n'); 

      break;

   end

   if abs((max(f) - min(f))/min(f))  < s.TolFun

      fprintf(1, 'optimisation terminated sucessfully (TolFun criterion)\n'); 

      break;

   end 

end

if i == s.MaxIter

   fprintf(1, 'Warning : maximim number of iterations exceeded\n'); 

end

% update model structure

[f, idx] = min(F);
p        = P(idx,:);
model    = train(set(model, 'parameters', p), x, t, varargin{:});

% bye bye...

