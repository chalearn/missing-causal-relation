# This Makefile is used under Linux

MATLABDIR ?= /usr/local/matlab
CXX = g++
CFLAGS = -Wall -O3 -fPIC -I$(MATLABDIR)/extern/include

MEX = $(MATLABDIR)/bin/mex
MEX_OPTION = CC\#$(CXX) CFLAGS\#"-Wall -O3 -fPIC"

all:    svmpredict svmtrain

svmpredict:     svmpredict.c svm.h svm.o svm_model_matlab.o
	$(MEX) $(MEX_OPTION) svmpredict.c svm.o svm_model_matlab.o

svmtrain:       svmtrain.c svm.h svm.o svm_model_matlab.o
	$(MEX) $(MEX_OPTION) svmtrain.c svm.o svm_model_matlab.o

svm_model_matlab.o:     svm_model_matlab.c svm.h
	$(CXX) $(CFLAGS) -c svm_model_matlab.c

svm.o:  svm.cpp svm.h
	$(CXX) $(CFLAGS) -c svm.cpp

clean:
	rm -f *.o; rm -f *.mex*; rm -f *obj

