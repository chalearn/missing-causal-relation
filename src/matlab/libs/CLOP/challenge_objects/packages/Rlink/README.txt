This directory contains a simple unidirectional Matlab to R interface.

fevalR.m:	On the Matlab side, type:
		fevalR("R_function_name", "arg1", argval1, "arg2", argval2, ...);

fevalR.R:	On the R side, this function gets called via a function call.
		The data passed back and forth are written to disk.

If you have an R function that you want executed via this interface, just put it in this directory.

To be able to run this code, you will have to install R. The first time you execute fevalR.m, you will be asked the path (directory where the executable is). This path will be stored in the file __Rpath.txt.
DELETE THIS FILE if you change your R installation.