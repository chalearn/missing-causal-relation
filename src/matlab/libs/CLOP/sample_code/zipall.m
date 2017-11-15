function zip_name = zipall(model_name, resu_dir, zip_dir)
%zip_name = zipall(model_name, resu_dir, zip_dir)
% The results are stored in [resu_dir '/' model_name].
% They will end up in [zip_dir '/' model_name '.zip'].

zip_name=[];
resu_dir=[resu_dir '/' model_name];
if ~isdir(resu_dir), 
%    warning('No such directory');
    return
end
D = dir(resu_dir);
[resu_files{1:length(D)}] = deal(D.name);
resu_files(1:2) = [];
zip([zip_dir '/' model_name], resu_files, resu_dir);

zip_name=[zip_dir '/' model_name '.zip'];

