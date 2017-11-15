/******************************************************************************

File        : unbuffer.c

Date        : Sunday 21st January 2007

Author      : Dr Gavin C. Cawley

Description : Turn off the buffering of stdout under MATLAB.

History     : 21/1/2007 - v1.00

Copyright   : (c) G. C. Cawley, January 2007.

******************************************************************************/

#include <stdio.h>

#include "mex.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
   /* check number of input and output arguments */

   if (nrhs != 0)
   {
      mexErrMsgTxt("too many input arguments.");
   }
   else if (nlhs != 0)
   {
      mexErrMsgTxt("Too many output arguments.");
   }

   /* turn off buffering on stdout */

   setvbuf(stdout, (char*)NULL, _IONBF, 0);

   /* bye bye... */
}

/**************************** That's all Folks!  *****************************/

