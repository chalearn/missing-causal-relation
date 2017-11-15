README FILE
-----------
===================================================================================================
CODE USED FOR
Hybrid learning using mixture models and artificial neural networks
Mehreen Saeed. In Hands-on pattern recognition challenges in data representation,
model selection, and performance prediction, editors: Isabelle Guyon, Gavin Cawley, Gideon Dror and Amir Saffari, accepted for publication.  
http://www.clopinet.com/ChallengeBook.html=====================================================================================================




The following are enclosed in the zip file:

Place the following folders in the clop or spider directory.  (best to put them in spider\clust)

CLOP OBJECTS
=============
emAll: Object for both continuous and binary feature datasets
emGauss: Object for only continuous feature datasets
emBernoulli: Object for binary feature datasets
remAll:  Same as emAll but uses regularized version of EM for Bernoulli mixtures (these were not used for the challenge but give better results)
remBernoulli: Same as emBernoulli but uses regularized version of EM for Bernoulli mixtures (these were not used for the challenge but give better results)


C++ CODE
========
MixModels: Has C++ source files for making mixture models and also has the .dll files (debug versions).  Place it in the current path directory from where the .dll files can be executed
main.cpp in MixModels shows how you can run the program only in C++


SINGLE FILES
============
Single files that should be in matlab path:

elim_for_c.m


EXAMPLES
========
sylvaEperiments, GinaExperiments, adaExperiments, NovaExperiments and GinaExperiments were used for determining the parameters to be used for final entry submissions.  Various models that were submitted for the challenge are in the submitted.txt file.  You can get similar results by using these models

KERNEL FOR SVM
==============
use the following if entropy kernel is to be tried....this doesn't give much benefit.  RBF kernels perform better
entropy.m place it in the @kernel folder in CLOP objects

libsvm_classifier_spider: folder has the modified source code for libsvm
svm folder: has the modified svm object
