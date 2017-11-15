function ebar=error_bar(ber, npos)
%ebar=error_bar(ber, npos)
% Compute the error bar for unbalanced classes.
% Inputs:
% ber -- balanced error rate.
% npos -- number of positive examples.
% Returns:
% ebar -- Error bar.

% Isabelle Guyon -- isabelle@clopinet.com -- June 2005

ebar=sqrt(ber*(1-ber)/(2*npos));