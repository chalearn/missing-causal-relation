function b = loadobj(a)
% Load an algorithm object from .mat file to workspace
%
% Amir Reza Saffari Azar, amir@ymer.org, Apr. 2006

if isa(a , 'algorithm')
    b = a;
else
    b = algorithm(a.name);
end