function save_outputs(filename, mat, overwrite_flag)
%save_outputs(filename, mat, overwrite_flag)
% Save vectors or matrices in the space delimited format.
% Inputs:
% filename          -- Name of the file to write to.
% mat               -- A vector or a matrix.
% overwrite_flag    -- 0/1 flag to choose whether the file should be
%                      overwritten if it exists.

% Isabelle Guyon -- January 2005 -- isabelle@clopinet.com
% Modified October 2005 after Amir Reza Saffari Azar

if nargin<3,
    overwrite_flag=1;
    % Force overwrite unless precised
end

ok=1;
if ~overwrite_flag & exist(filename) == 2
	ok=input(['File ' filename ' already exists, overwrite [yes=1/no=0]? ']);
end

if ok 

    mat=full(mat);
    fp=fopen(filename, 'w');
    if size(mat,2)==1
        fprintf(fp, '%g\n', mat);
    else
        for i=1:size(mat,1)
            fprintf(fp, '%g ', mat(i,:));
            fprintf(fp, '\n');
        end
    end
    fclose(fp);

end