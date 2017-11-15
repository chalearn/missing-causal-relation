function varargout = unbuffer(varargin)
%
% UNBUFFER - turn off buffering of standard output stream
%
%    UNBUFFER turns of the buffering of the standard output stream used to
%    write information to the terminal, so that characters are written to
%    the screen immediately.  This is useful if you use the '\r' escape
%    character to give a progress indicator that is updated without writing
%    a new line.

%
% File        : unbuffer.m
%
% Date        : Sunday 21st January 2007
%
% Author      : Gavin C. Cawley
%
% Description : MATLAB help file and recompilation script for unbuffer.c - a
%               MEX file used to turn off the buffering of stdout.
%
% History     : 21/01/2007 - v1.00
%
% Copyright   : (c) Dr Gavin C. Cawley, January 2007.
%

% store the current working directory

cwd = pwd;

% find out name of the currently running m-file (i.e. this one!)

name = mfilename;

% find out what directory it is defined in

dir             = which(name);
dir(dir == '\') = '/';
dir             = dir(1:max(find(dir == '/')-1));

% try changing to that directory

try

   cd(dir);

catch

   % this should never happen, but just in case!

   cd(cwd);

   error(['unable to locate directory containing ''' name '.m''']);

end

% try recompiling the MEX file

try

   fprintf(1, 'recompiling ''%s''...\n', name);

   mex([name '.c']);

catch

   % this may well happen happen, get back to current working directory!

   cd(cwd);

   error('unable to compile MEX version of ''%s''%s\n%s%s', name, ...
         ', please make sure your', 'MEX compiler is set up correctly', ...
         ' (try ''mex -setup'').');


end

% change back to the current working directory

cd(cwd);

% refresh the function and file system caches

rehash;

% try to invoke MEX version using the same input and output arguments

[varargout{1:nargout}] = feval(name, varargin{:});

% bye bye...

