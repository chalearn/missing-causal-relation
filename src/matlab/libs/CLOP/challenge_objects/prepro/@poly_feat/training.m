function [dat,algo] =  training(algo,dat)
%[dat,algo] =  training(algo,dat)
% Train a poly_feat feature construction preprocessor.
% Inputs:
% algo -- A "poly_feat" learning object.
% dat -- A training data object.
% Returns:
% dat -- Preprocessed data.
% algo -- The poly_feat object.

% Isabelle Guyon -- February 2009 -- isabelle@clopinet.com

if algo.algorithm.verbosity>0
    disp(['training ' get_name(algo) '... '])
end

dat=test(algo, dat);

dat=set_name(dat,[get_name(dat) ' -> ' get_name(algo)]); 

        








