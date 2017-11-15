function a = saveobj(a)
%	SAVEOBJ     A method to save ENSEMBLE object

% Amir Reza Saffari Azar, amir@ymer.org
% Based on code by Isabelle Guyon -- isabelle@clopinet.com -- October 2005

global CleanObject

if exist('CleanObject' , 'var')
    if CleanObject
        for i = 1:length(a.child)
            a.child{i}  = saveobj(a.child{i});
        end

        a.algorithm.saved = 1;
    else
        a = a;
    end
else
    a = a;
end