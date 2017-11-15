function a = saveobj(a)
%	SAVEOBJ     A method to save SVC object

% Amir Reza Saffari Azar, amir@ymer.org
% Based on code by Isabelle Guyon -- isabelle@clopinet.com -- October 2005

global CleanObject

if exist('CleanObject' , 'var')
    if CleanObject
        if nargin == 1
            a.alpha=[];
            a.b0=0;
            a.nob=0;
            a.nSV=[];
            a.nLabel=[];
            a.W=[];
        else
            a = svc;
        end

        % Clears the support vectors
        a.Xsv=[];

        a.algorithm.saved = 1;
    else
        a = a;
    end
else
    a = a;
end