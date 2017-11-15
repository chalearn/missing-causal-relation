/* 
 * This is a MEX-file for MATLAB.  
 * Copyright 1984-2000 The MathWorks, Inc.
 * All rights reserved.
 *=================================================================*/
/* $Revision: 1.5 $ */

#include <mex.h>
#include <assert.h>
#include "mexarg.h"
#include "em.h"

//This is for BINOMIAL MIXTURES 
//we need two inputs i.e. the number of mixtures and the input array
//we will output the probabilities and the priors of each mixture
//so we have two inputs first is a scalar
//the other input is a 2d double matrix
//the first output will be the prob matrix so its 2d double array
//the second output will be the prob array so its a 1d double array
void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	mexarg arg;
	int row,col;
	double *Features;
	double iterations,mixtures;
	int i,j;
	int index = 0;

	if( !(arg.require(nrhs,prhs,"X") & 
		  arg.require(nrhs,prhs,"iterations") & 
		  arg.require(nrhs,prhs,"mixtures")  
		))
	{		
		mexPrintf("LibEM interface");
		mexPrintf("\nUsage: [Prob Prior]="\
					"libem({\'X\',doublematrix},{\'iterations\',scalar},\n"\
				  "{\'mixtures\',scalar}\n");
		return;
	}

	mxArray *X;
	if (arg.getmatrix(nrhs,prhs,"X",&X))
	{
		row = mxGetM( X);
		col = mxGetN(X);
		Features = mxGetPr(X);
	}

    arg.getscalar(nrhs,prhs,"iterations",&iterations);
    arg.getscalar(nrhs,prhs,"mixtures",&mixtures);



	//lets do the em part
	//-------------------------------------------------------
	DataEM em((int)mixtures,POSITIVE,BINOMIAL);
	em.Train(Features,row,col,(int)mixtures,(int)iterations);
	//-------------------------------------------------------


	//now lets copy the output if arg specified
	if(nlhs>0)	
	{
		index = 0;
		plhs[0]=mxCreateDoubleMatrix((int)mixtures,(int)col,mxREAL);		
		double *prob=mxGetPr(plhs[0]);

		//matlab uses the other order
		for(j=0;j<col;j++)
		{
			for(i=0;i < mixtures;i++)
			{
				prob[index] = em.m_Prob[i][j];
				index++;
			}
		} 		

		for (i=0;i<mixtures;++i)
		{	for (j=0;j<col;++j)
			{	
				mexPrintf("%f ",em.m_Prob[i][j]);
			}
			mexPrintf("\n");
		}	

	}
	//lets copy the priors if arg is specified
	if (nlhs>1)
	{
		index = 0;
		plhs[1]=mxCreateDoubleMatrix((int)mixtures,1,mxREAL);		
		double *prob=mxGetPr(plhs[1]);
		for(i=0;i < mixtures;i++)
		{
			prob[index] = em.m_Prior[i];
			index++;
		}
		for (i=0;i<mixtures;++i)
		{	mexPrintf("%f ",em.m_Prior[i]);
			mexPrintf("\n");
		}	

	}



}