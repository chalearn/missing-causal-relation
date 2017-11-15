function a = saveobj(a)
%	SAVEOBJ     A method to save KRIDGE object

% Amir Reza Saffari Azar, amir@ymer.org
% Based on code by Isabelle Guyon -- isabelle@clopinet.com -- October 2005

global CleanObject

if exist('CleanObject' , 'var')
    if CleanObject
        if nargin == 1
            a.alpha = [];
            a.b0    = 0;
            a.Xsv   = [];
            a.W     = [];
            a.mse   = 0;
            a.mse_loo   = 0;
            a.errate    = 0;
            a.err_loo   = 0;
        else
            a = kridge;
        end

        % Clears the pattern matrix
        a.Xsv=[];

        a.algorithm.saved = 1;
    else
        a = a;
    end
else
    a = a;
end