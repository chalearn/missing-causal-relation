function Y=read_labels(filename)
%Y=read_labels(filename)
% Read the labels.

% Isabelle Guyon -- isabelle@clopinet.com -- September 2005

if fcheck(filename) 
    Y=load(filename);
else
    Y=[];
end
    