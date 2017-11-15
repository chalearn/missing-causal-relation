function ok=save_model(modelFilename, model, overwrite_flag, cleanup_flag)
%ok=save_model(modelFilename, model, overwrite_flag, cleanup_flag)
% Save CLOP models in Matlab format.
% Inputs:
% modelFilename     -- Name of the file to write to.
% model             -- A model (a challenge learning object).
% overwrite_flag    -- 0/1 flag to choose whether the file should be
%                       overwritten if it exists. Default 1.
% cleanup_flag      -- 0/1 flag to choose whether to remove the 
%                       trained parameters (keep only the hyperparameters).
%                       Default 0, save the whole model.
% NOTE: You can just use save('modelfile', 'modelname')
% to save a model, if you don't care about overwriting
% and about cleaning your object (removing the trained
% parameters that make it REALLY big sometimes.)
% Returns:
% ok                -- Saving status: 1 if ok, 0 if not saved.

% Isabelle Guyon -- October 2005 -- isabelle@clopinet.com
% Modified by Amir R. Saffari, amir@ymer.org
% Remodified, IG may 15, 06.
            
global CleanObject

%if ~isclop(model)
%    error('This is not a valid CLOP model');
%end

if nargin < 3,
    overwrite_flag=1;
    % Force overwrite unless precised
end

if nargin < 4,
    cleanup_flag = 0;
    % Save the trained parameters
end

CleanObject = cleanup_flag;

if isempty(strfind(modelFilename, '.mat'))
    modelFilename = [modelFilename '.mat'];
end

ok = 1;
if ~overwrite_flag & exist(modelFilename) == 2
    ok = input(['File ' modelFilename ' already exists, overwrite [yes=1/no=0]? ']);
end

if ok
    save temp12345 model; % ugly but it works
    movefile('temp12345.mat', modelFilename);
end

clear CleanObject