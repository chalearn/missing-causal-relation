function results = fevalR(func, varargin)
%results = fevalR(func)
%results = fevalR(func, arg1, arg2, ...)
% Function to call R functions. Requires the R package to be installed.
% See http://www.r-project.org/
% Inputs:
% func                  -- function name (given as a string)
% argname1, argval1, argname2 argval2, ...       
%                       -- function argument names and values
% Returns:
% results               -- function results

% Isabelle Guyon -- isabelle@clopinet.com -- August 2006

cleanup=1; % Remove files after use
debug=0;   % Print messages along the way

% Get the correct paths
Rpath=[];
Rdir=which('fevalR');
Rdir(Rdir=='\')='/';
slash=find(Rdir=='/');
Rdir=Rdir(1:slash(end));

if (exist([Rdir '__Rpath.txt']) == 2)
    Rpath=textread([Rdir '__Rpath.txt'], '%s', 'delimiter', '\n');
    Rpath=Rpath{1};
else
    while ~(exist([Rpath 'R.exe']) == 2)
        Rpath=input('Please enter a correct path for R.exe (between quotes): ');
        Rpath(Rpath=='\')='/';
        ll=length(Rpath);
        if ~strcmp(Rpath(ll), '/'), Rpath=[Rpath '/']; end
        pfile=fopen([Rdir '__Rpath.txt'], 'w');
        fprintf(pfile, '%s', Rpath);
        fclose(pfile);
    end
end

% Keep track of auxiliary files
fn=0;
fl={};

if debug, fprintf('Saving arguments to disk ...\n'); end

% Save the function name as text
fn=fn+1; fl{fn}=[Rdir '__function_called.txt'];
fp=fopen(fl{fn}, 'w');
fprintf(fp, '%s\n', func);
fclose(fp);
% Save the number of arguments as text
fn=fn+1; fl{fn}=[Rdir '__arg_num.txt'];
fp=fopen(fl{fn}, 'w');
fprintf(fp, '%d\n', length(varargin)/2);
fclose(fp);
% Save the argument names
fn=fn+1; fl{fn}=[Rdir '__arg_names.txt'];
fp=fopen(fl{fn}, 'w');
for i=1:length(varargin)/2
    argname=varargin{2*i-1};
    fprintf(fp, '%s\n', argname);
end
fclose(fp);    
% Temporarily save the arguments as Matlab matrices 
% We need to used V6 because higher releases are unsupported
% by the R.matlab library
for i=1:length(varargin)/2
    argval=varargin{2*i};
    fn=fn+1; fl{fn}=[Rdir '__arg' num2str(i) '.mat'];
    save(fl{fn}, 'argval', '-V6');
end

% Call the R function via a system call
if debug
    call_string=['"' Rpath 'R" --no-save --args "' Rdir '" <"' Rdir 'fevalR.r"']
else
    call_string=['"' Rpath 'R" --no-save --args "' Rdir '" <"' Rdir 'fevalR.r"']
    %call_string=['"' Rpath 'R" --no-save --quiet --slave --args "' Rdir '" <"' Rdir 'fevalR.r"']
end
system(call_string);

% Read the outputs
fn=fn+1; fl{fn}=[Rdir '__resu.mat'];
results=load(fl{fn});

% Clean up?
if cleanup
    for i=1:fn
        delete(fl{i});
    end
end
    
