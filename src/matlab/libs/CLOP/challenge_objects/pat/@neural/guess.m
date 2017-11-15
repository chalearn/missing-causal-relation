function g=guess(a)

% Out-of-bag estimated error rate for training data
g=a.forest.errtr(end)/100;