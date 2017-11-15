function a = saveobj(a)
%	SAVEOBJ     A method to save RF object

% Amir Reza Saffari Azar, amir@ymer.org
% Based on code by Isabelle Guyon -- isabelle@clopinet.com -- October 2005

global CleanObject

if exist('CleanObject' , 'var')
    if CleanObject
        if nargin == 1
            a.targets=[];
            a.param=[];
        else
            a = rf;
        end

        a.forest=[];

        a.algorithm.saved = 1;
    else
        a = a;
    end
else
    a = a;
end