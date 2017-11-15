function fix(net)
%
% FIX - Fix a concrete generalised kernel machine sub-class
%
%    FIX(GKM) creates a new directory in the current working directory
%    implementing a new class of GKM object.  The name of the directory
%    is decided by the 'acronym' property of the GKM.

%
% File        : @gkm/fix.m
%
% Date        : Friday 24th August 2007
%
% Author      : Dr Gavin C. Cawley
%
% Description : Fix a concrete generalised kernel machine sub-class.
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

[success,message,messageid] = mkdir(['@' net.acronym]);

outfd = fopen(['@' net.acronym '/' net.acronym '.m'], 'w');

[Y,M,D,H,MI,S] = datevec(now);

month = {'January', 
         'February', 
         'March', 
         'April',
         'May',
         'June',
         'July',
         'August',
         'September',
         'October',
         'November',
         'December'};

day = {'Sunday',
       'Monday',
       'Tuesday',
       'Wednesday',
       'Thursday',
       'Friday',
       'Saturday'};

if outfd ~= -1

   directory = which([mfilename '(' class(net) ')']);

   infd = fopen([directory(1:end-5) '/template.m'], 'r');

   if infd ~= -1

      while 1

         str = fgetl(infd);

         if ~ischar(str)

            break;

         end

         % perform substitutions

         str = regexprep(str, '<acronym>',    net.acronym);
         str = regexprep(str, '<ACRONYM>',    upper(net.acronym));
         str = regexprep(str, '<canonical>',  net.canonical);
         str = regexprep(str, '<invlink>',    char(net.invlink));
         str = regexprep(str, '<loss>',       char(net.loss));
         str = regexprep(str, '<W>',          char(net.W));
         str = regexprep(str, '<name>',       net.name);
         str = regexprep(str, '<D>',          num2str(D));
         str = regexprep(str, '<M>',          num2str(M));
         str = regexprep(str, '<Y>',          num2str(Y));
         str = regexprep(str, '<month>',      month{M});
         str = regexprep(str, '<Day>',        day(weekday(date)));
         str = regexprep(str, '<day>',        theday(D));

         % write line

         fprintf(outfd, '%s\n', str);

      end

      fclose(infd);

   end

   fclose(outfd);

end

function s = theday(d)

s = num2str(d);

switch s(end)
   case '1' 
      s = [s, 'st'];
   case '2' 
      s = [s, 'nd'];
   case '3'
      s = [s, 'rd'];
   otherwise 
      s = [s, 'th'];
end

% bye bye...

