function [KM] = get_kernel(varargin)

% [KM] = get_kernel(k,d1,[d2],[ind1],[ind2])
%
% Calculate the kernel with specific indexed data from 
% datasets d1 and (optionally) d2.
% If d2 is not given it is assumed to make the matrix between d1 and itself

KM = calc(varargin{:});
