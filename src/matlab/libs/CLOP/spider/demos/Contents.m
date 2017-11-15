% 
% ------------------------------------------------------------------------
%
% THE SPIDER DEMOS
% ================
%
% The demos can be accessed by changing directory to the appropriate demo
% in [spider_path 'demos/'] and then the directory given below,
% and executing the M-files, called go.m, go2.m, go3.m, ... 
% The demos either generate toy data or use the colon cancer microarray
% data from Alon et. al. or the multi-class Yeast data of Brown et al.
%
% Demo descriptions:
%
% c45/go            - compares svms and c4.5 on multi-class yeast data.
% c45/go2           - compares svms and c4.5 on micro-array colon cancer data.
%
% clust/go          - compares spectral & k-means clustering on 
%                     the 2-D ring problem
%
% feat_sel/go       - compares rfe, l0 and fisher on a toy problem.
% feat_sel/go2      - compares svm rfe with svm on a non linear toy problem.
% feat_sel/go3      - compares mc_svm and one_vs_rest(svm) both with nonlinear
%                     rfe feature selection on the Brown Yeast dataset
% feat_sel/go4      - compares l0 with FSV on the colon dataset
% feat_sel/go5      - compares one_vs_rest svms with rfe and l0 or no
%                     feature selection on the Brown Yeast data
%
% mclass/go         - compares one-vs-rest svm and knn with different 
%                     k on the Brown Yeast dataset (5 classes).
% mclass/go2        - compares multi-class svm with one against the
%                     rest, one_vs_one svms and fisher  on 
%                     the Brown Yeast dataset.
% mclass/go3        - runs mc_svm with l0 feature selection on Yeast data.
% mclass/go4        - compares kde, one_vs_rest and 1-nn on the Yeast data.
%
% mod_sel/go        - shows simple model selection selecting the
%                     value of sigma of an RBF kernel.
% mod_sel/go2       - model selection on the Yeast (5 classes) dataset.
%                     The models are: one_vs_rest, one_vs_one, c45, knn.
% mod_sel/go3       - model selection selecting the value of k of k-nn
%
% optimizers/go     - This demo compares several svm optimization codes using 
%                     a hard margin. 
%                     The optimizers are: svmlight,quadprog,andre and leon's 
%                     and libsvm.
% optimizers/go2    -This demo compares libsvm and andre's 
%                     optimizers on a regression
%                     problem using espilon-SVR and nu-SVR. 
%
% ------------------------------------------------------------------------

% stability/go       -Maximum Stability algorithm demo




