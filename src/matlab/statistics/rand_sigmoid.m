function [ y ] = rand_sigmoid( x, beta )
%SIGMOID Summary of this function goes here
%   Detailed explanation goes here
    p = 1 ./ (1 + exp(-beta * x));
    r = rand(size(x));
    y = r<p;
end

