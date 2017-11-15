/* 
 * This is a MEX-file for MATLAB.  
 * Copyright 1984-2000 The MathWorks, Inc.
 * All rights reserved.
 *=================================================================*/
/* $Revision: 1.5 $ */

#include <assert.h>
#include <mex.h>
#include "mexarg.h"
#include "em.h"


//we need three inputs i.e. the number of mixtures and the input array and iterations
//the fourth input is optional, i.e., the intitial prob values for each mixture
//we will output the probabilities and the priors of each mixture
//so we have two inputs first is a scalar
//the other input is a 2d double matrix
//the first output will be the prob matrix so its 2d double array
//the second output will be the prob array so its a 1d double array
void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	mexarg arg;
	int row,col;
	int row1=0,col1=0;
	double *Features,*InitVectors=NULL;
	double iterations,mixtures;
	double seedVal=0;
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

	//initial values for initialization of parameters for Bernoullis ... optional
	mxArray *initVals=NULL;
	if (arg.getmatrix(nrhs,prhs,"InitVectors",&initVals))
	{
		row1 = mxGetM(initVals);
		col1 = mxGetN(initVals);
		InitVectors = mxGetPr(initVals);
	}

    arg.getscalar(nrhs,prhs,"iterations",&iterations);
    arg.getscalar(nrhs,prhs,"mixtures",&mixtures);

	//optional parameter seed added to time for initializing random number generator
	if (arg.require(nrhs,prhs,"seedVal"))
	{
	    arg.getscalar(nrhs,prhs,"seedVal",&seedVal);

	}



	//lets do the em part
	//-------------------------------------------------------
	DataEM em((int)mixtures);
	em.InitTrain(Features,row,col,(int)mixtures,seedVal);

	if (InitVectors)
	{
		assert(col1 == col); //rows don't have to be equal
		int c,r;
		int index = 0;
		for (c=0;c<col1;++c)
		{	for (r=0;r<row1;++r)
			{
				if (r<mixtures)  //we don't want to exceed the bounds of array
					em.m_Prob[r][c] = InitVectors[index];
				index++;
			}
		}
		
	
	}
	em.TrainOnly((int)iterations);
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

//		for (i=0;i<mixtures;++i)
//		{	for (j=0;j<col;++j)
//			{	
//				mexPrintf("%f ",em.m_Prob[i][j]);
//			}
//			mexPrintf("\n");
//		}	

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

