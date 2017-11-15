function ok=use_spider_clop(model_dir)
% ok=use_spider_clop(model_dir)
% Set the path for the spider and clop packages

%%% IG: this is made more robust:

ok=0;

this_dir=pwd;
if nargin<1, 
    model_dir=which('use_spider_clop'); 
    model_dir=model_dir(1:strfind(model_dir, 'use_')-1)
end

% Add the sample code
warning off
addpath([model_dir '/sample_code']);
warning on
if ~(exist('code_version.m') == 2)
    disp 'Wrong code path: the path should include the sample_code directory';
    cd(this_dir);
    return
else
    fprintf('Sample code version : %s\n', code_version('sample_code'));
end

% Add the Spider
cd([model_dir '/spider']);
if ~(exist('use_spider.m') == 2)
    disp 'Wrong code path: the path should include the spider directory';
    cd(this_dir);
    return
end
warning off
use_spider;
warning on

% Add CLOP
cd([model_dir '/challenge_objects']);
if ~(exist('use_clop.m') == 2)
    disp 'Wrong code path: the path should include the challenge_objects directory';
    cd(this_dir);
    return
end
warning off
use_clop;
warning on

cd(this_dir);

ok=1;