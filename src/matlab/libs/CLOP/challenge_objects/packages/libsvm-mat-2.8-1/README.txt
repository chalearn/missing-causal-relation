-----------------------------------------------
--- Document for MATLAB interface of LIBSVM ---
-----------------------------------------------

Introduction
============

This tool provides a simple interface to LIBSVM, a library for support vector
machines (http://www.csie.ntu.edu.tw/~cjlin/libsvm). It is very easy to use as
the usage and the way of specifying parameters is the same as that of LIBSVM.

Installation
============

# Two makefiles are provided: 
# Makefile_orig: the original makefile from the authors of the package.
# Makefile_amir: a makefile using gcc32 instead of g++, change proposed by
# Amir Reza Saffari Azar, tested under Linux, October 2005.
# In order to compile it in Linux, you have to use "make -f Makefile_orig" 
# or "make -f Makefile_amir". 
# Micheal Wild also identified a bug fix from Matlab, see the file 
# MATLAB 7_0 (R14)MEXproblem.html or the link
# http://www.mathworks.com/support/solutions/data/1-QBCS1.html?solution=1-QBCS1

# Here are the original installation instructions:

On Unix systems, we recommend using GNU g++ as your compiler and
type 'make' to build 'svmtrain.mexglx' and 'svmpredict.mexglx'.
Note that we assume your MATLAB is installed in '/usr/local/matlab',
if not, please change MATLABDIR in Makefile.

Example:
        linux> make

On Windows systems, pre-built 'svmtrain.dll' and 'svmpredict.dll' are
included in this package, so no need to conduct installation. If you
have modified the sources and would like to re-build the package, type
'mex -setup' in MATLAB to choose a compiler for mex first. Then type
'make' to start the installation.

Example:
        matlab> mex -setup
        (ps: MATLAB will show the following messages to setup default compiler.)
        Please choose your compiler for building external interface (MEX) files: 
        Would you like mex to locate installed compilers [y]/n? y
        Select a compiler: 
        [1] Microsoft Visual C/C++ version 6.0 in C:\Program Files\Microsoft Visual Studio 
        [0] None 
        Compiler: 1
        Please verify your choices: 
        Compiler: Microsoft Visual C/C++ 6.0 
        Location: C:\Program Files\Microsoft Visual Studio 
        Are these correct?([y]/n): y

        matlab> make

Usage
=====

matlab> model = svmtrain(training_label_vector, training_instance_matrix, [,'libsvm_options']);

        -training_label_vector:
            An m by 1 vector of training labels.
        -training_instance_matrix:
            An m by n matrix of m training instances with n features.
            It can be dense or sparse.
        -libsvm_option:
            A string of training options in the same format as that of LIBSVM.

matlab> [predicted_label, accuracy] = svmpredict(testing_label_vector, testing_instance_matrix, model [,'libsvm_option']);

        -testing_label_vector:
            An m by 1 vector of prediction labels. If labels of test
            data are unknown, simply use any random values.
        -testing_instance_matrix:
            An m by n matrix of m testing instances with n features.
            It can be dense or sparse.
        -model:
            The output of svmtrain.
        -libsvm_option:
            A string of testing options in the same format as that of LIBSVM.

Returned Model Structure
========================

The 'svmtrain' function returns a model which can be used for future
prediction.  It is a structure and is organized as [Parameters, nr_class,
totalSV, rho, Label, ProbA, ProbB, nSV, sv_coef, SVs]:

        -Parameters: parameters
        -nr_class: number of classes; = 2 for regression/one-class svm
        -totalSV: total #SV
        -rho: -b of the decision function(s) wx+b
        -Label: label of each class; empty for regression/one-class SVM
        -ProbA: pairwise probability information; empty if -b 0 or in one-class SVM
        -ProbB: pairwise probability information; empty if -b 0 or in one-class SVM
        -nSV: number of SVs for each class; empty for regression/one-class SVM
        -sv_coef: coefficients for SVs in decision functions
        -SVs: support vectors

If you do not use the option '-b 1', ProbA and ProbB are empty
matrices. If the '-v' option is specified, cross validation is
conducted and the returned model is just a scalar: cross-validation
accuracy for classification and mean-squared error for regression.

More details about this model can be found in LIBSVM FAQ
(http://www.csie.ntu.edu.tw/~cjlin/libsvm/faq.html) and LIBSVM
implementation document
(http://www.csie.ntu.edu.tw/~cjlin/papers/libsvm.pdf).

Result of Prediction
====================

The function 'svmpredict' has two outputs. The first one,
predicted_label, is in general a vector of predicted labels. If '-b 1'
is specified as an option of 'svmpredict' and the input model
possesses probability information, it is a matrix where additional
elements in each row are probabilities that the test data is in each
class. Note that the order of classes is the same as Label in the
model structure. The second output, accuracy, is a vector including
accuracy (for classification), mean squared error, and squared
correlation coefficient (for regression).

Examples
========

matlab> load heart_scale.mat
matlab> model = svmtrain(heart_scale_label, heart_scale_inst, '-c 1 -g 2');
matlab> [predict_label, accuracy] = svmpredict(heart_scale_label, heart_scale_inst, model); % test the training data

For probability estimates, you need '-b 1' for training and testing:

matlab> load heart_scale.mat
matlab> model = svmtrain(heart_scale_label, heart_scale_inst, '-c 1 -g 2 -b 1');
matlab> load heart_scale.mat
matlab> [predict_label, accuracy] = svmpredict(heart_scale_label, heart_scale_inst, model, '-b 1');

Other Utilities
===============

A simple matlab program read_sparse.m reads files in libsvm format: 

[svm_lbl, svm_data] = read_sparse(fname); 

Two outputs are labels and instances, which can then be used as inputs
of svmtrain or svmpredict. This code was initiated by Hsuan-Tien Lin
from Caltech and rewritten by Rong-En Fan from National Taiwan
University.

Additional Information
======================

This interface was initially written by Jun-Cheng Chen, Kuan-Jen Peng,
Chih-Yuan Yang and Chih-Huai Cheng from Department of Computer
Science, National Taiwan University. The current version was prepared
by Rong-En Fan. If you find this tool useful, please cite LIBSVM as
follows

Chih-Chung Chang and Chih-Jen Lin, LIBSVM : a library for
support vector machines, 2001. Software available at
http://www.csie.ntu.edu.tw/~cjlin/libsvm

For any question, please contact Chih-Jen Lin <cjlin@csie.ntu.edu.tw>.
