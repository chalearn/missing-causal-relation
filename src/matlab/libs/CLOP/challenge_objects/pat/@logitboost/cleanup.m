function cleanup(algo, all)
% Function used to remove forests stored in R format
% algo: a forest
% all: a flag. If 0 or default, just remove this forest; otherwise remove
% all forests.

% Isabelle Guyon -- isabelle@clopinet.com -- September 2006

Rdir=which('fevalR');
Rdir(Rdir=='\')='/';
slash=find(Rdir=='/');
Rdir=Rdir(1:slash(end));

if nargin<2, all=0; end

if all
    answer=input('Really delete all forests? [yes=1] ');
    if answer==1
        delete([Rdir '*forest.Rdata']);
    end
else
    answer=input(['Really delete ' algo.forest.filename '? [yes=1] ']);
    if answer==1
        delete([Rdir algo.forest.filename]);
    end
end