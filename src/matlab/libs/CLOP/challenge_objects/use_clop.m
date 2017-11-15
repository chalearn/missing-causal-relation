function pOut = use_clop(add)
% USE_CLOP   get ready to use the CLOP (Challenge Learning Object Package) toolbox
% 
% To install the CLOP toolbox, add the CLOP root directory permanently
% to your MATLAB search path using, for example, PATHTOOL.
% 
% To begin using the CLOP, call USE_CLOP. If you use the Spider all
% the time, it would be a good idea to call USE_CLOP in your startup.m
% file.
% 
% USE_CLOP
% USE_CLOP(1)
%     Adds the Clop subdirectories to the MATLAB search path, and also
%     sets up the default global options.
% 
% USE_CLOP(0)
%     Removes the Clop subdirectories from the MATLAB search path.
% 
% P = USE_CLOP
%     Does not add or remove paths, but returns a cell array of path
%     strings that would be added. They can then be added or removed
%     manually with ADDPATH(P{:}) or RMPATH(P{:}). Global options are not
%     set up.

if nargin < 1, add = 1; end

if nargin<1
disp(' ');
disp('CLOP : additions to the Spider package for the model selection challenge.');
disp(' ');
disp('DISCLAIMER: ALL INFORMATION, SOFTWARE, DOCUMENTATION, AND DATA ARE PROVIDED "AS-IS"'); 
disp('ISABELLE GUYON AND/OR OTHER ORGANIZERS DISCLAIM ANY EXPRESSED OR IMPLIED WARRANTIES,'); 
disp('INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS'); 
disp('FOR ANY PARTICULAR PURPOSE, AND THE WARRANTY OF NON-INFRIGEMENT OF ANY THIRD PARTY''S'); 
disp('INTELLECTUAL PROPERTY RIGHTS. IN NO EVENT SHALL ISABELLE GUYON AND/OR OTHER ORGANIZERS'); 
disp('BE LIABLE FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER');
disp('ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF SOFTWARE, DOCUMENTS,'); 
disp('MATERIALS, PUBLICATIONS, OR INFORMATION MADE AVAILABLE FOR THE CHALLENGE.');
disp(' ');
end

fprintf('CLOP version : %s\n', code_version);

if datenum(version('-date')) >= datenum('May 6 2004')
 d = dbstack('-completenames');
 rootdir = fileparts(d(1).file);
else
 d = dbstack; 
 rootdir = fileparts(d(1).name);
end   

%%might be a relative path: convert to absolute

%-AMIR BEGINS-%
%olddir = pawd; cd(rootdir), rootdir = pawd; cd(olddir)
olddir = pwd; cd(rootdir), rootdir = pwd; cd(olddir)
%-AMIR ENDS-%

subdirs = {
    'basic'
    'pat'
    'feat_sel'
    'prepro'
    'postpro'
    'functions'
    'prior'
    'mod_sel'
    'clust'
    'clust/MixModels'
    'packages/isa_methods'
    'packages/RandomForest'
    'packages/gkm'
    'packages/Netlab'
    'packages/libsvm-mat-2.8-1' % 'packages/osu_svm3.00'
    'packages/lssvm'
    'packages/kridge'
    'packages/Rlink'
};
for i = 1:length(subdirs)
	s = cellstr(subdirs{i});
	subdirs{i} = fullfile(rootdir, s{:});
end

if nargout, pOut = subdirs; return, end
if ~add
	if datenum(version('-date')) >= datenum('June 18 2002')
        ws = warning('off', 'MATLAB:rmpath:DirNotFound');
    end

    rmpath(subdirs{:});
	
    if datenum(version('-date')) >= datenum('June 18 2002')
	    warning(ws)
    end
	return
end

% addpath(rootdir, subdirs{:})
addpath(subdirs{:})

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function d = updir(d)
d = fileparts(d);
if d(end)==filesep, d(end) = []; end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function d = pawd(d)

if nargin < 1
	if isunix
		[d err] = syscmd('echo $PWD'); % better (non-)resolution of symlinks, /.amd_mnt etc
		if ~isempty(err), d = pwd; end
	else
		d = pwd;
	end 
end
if ~isunix, return, end
[dd err] = syscmd(['pawd ''' d '''']);
if isempty(err), d = dd; end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [str, err] = syscmd(cmd)

err = '';
[failed str] = system(cmd);
str = deblank(str);
if failed
	err = sprintf('system call failed:\n%s\n%s', cmd, str);
	str = '';
	if nargout < 2, error(err), end
end
