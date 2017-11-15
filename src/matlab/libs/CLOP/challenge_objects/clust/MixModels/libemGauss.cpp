/* 
 * This is a MEX-file for MATLAB.  
 * Copyright 1984-2000 The MathWorks, Inc.
 * All rights reserved.
 *=================================================================*/
/* $Revision: 1.5 $ */

#include <mex.h>
#include "mexarg.h"
#include "assert.h"
#include "em.h"


//we need two inputs i.e. the number of mixtures and the input array
//The function will output the priors of each mixture
//It will also output the means of each mixture
//and will also ouptut the diagonal covariance matrices
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
		mexPrintf("\nUsage: [Mean DiagCov Prior]="\
					"libemGauss({\'X\',doublematrix},{\'iterations\',scalar},"\
				  "{\'mixtures\',scalar})\n");
		return;
	}

	mxArray *X;
	if (arg.getmatrix(nrhs,prhs,"X",&X))
	{
		row = mxGetM( X);		//total examples
		col = mxGetN(X);		//total features
		Features = mxGetPr(X);
	}

    arg.getscalar(nrhs,prhs,"iterations",&iterations);
    arg.getscalar(nrhs,prhs,"mixtures",&mixtures);



	//lets do the em part
	//-------------------------------------------------------
	DataEM em((int)mixtures, POSITIVE, GAUSSIAN);
	em.Train(Features,row,col,(int)mixtures,(int)iterations);
	//-------------------------------------------------------


	//now lets copy the output if arg specified
	//copy the means here
	//col is the total features
	if(nlhs>0)	
	{
		index = 0;
		plhs[0]=mxCreateDoubleMatrix((int)mixtures,(int)col,mxREAL);		
		double *mean=mxGetPr(plhs[0]);

		//matlab uses the other order
		for(j=0;j<col;j++)
		{
			for(i=0;i < mixtures;i++)
			{
				mean[index] = em.m_Mean[i][j];
				index++;
			}
		} 		

		mexPrintf("\n...Means...\n");
		for (i=0;i<mixtures;++i)
		{	for (j=0;j<col;++j)
			{	
				mexPrintf("%f ",em.m_Mean[i][j]);
			}
			mexPrintf("\n");
		}	

	}
	//copy covariance matrix here...they are diagonal matrices
	if(nlhs>1)	
	{
		index = 0;
		plhs[1]=mxCreateDoubleMatrix((int)mixtures,(int)col,mxREAL);		
		double *cov=mxGetPr(plhs[1]);

		//matlab uses the other order
		for(j=0;j<col;j++)
		{
			for(i=0;i < mixtures;i++)
			{
				cov[index] = em.m_Cov[i][j][j];
				index++;
			}
		} 		

		mexPrintf("\n...Cov matrices...\n");
		for (i=0;i<mixtures;++i)
		{	for (j=0;j<col;++j)
			{	
				mexPrintf("%f ",em.m_Cov[i][j][j]);
			}
			mexPrintf("\n");
		}	

	}

	//lets copy the priors if arg is specified
	if (nlhs>2)
	{
		index = 0;
		plhs[2]=mxCreateDoubleMatrix((int)mixtures,1,mxREAL);		
		double *prob=mxGetPr(plhs[2]);
		for(i=0;i < mixtures;i++)
		{
			prob[index] = em.m_Prior[i];
			index++;
		}
		mexPrintf("\n...Priors...\n");

		for (i=0;i<mixtures;++i)
		{	mexPrintf("%f ",em.m_Prior[i]);
			mexPrintf("\n");
		}	

	}
}
