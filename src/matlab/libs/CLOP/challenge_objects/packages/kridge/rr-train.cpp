#include <stdlib.h>
#include <memory.h>
#include <string.h>
#include <stdio.h>
#include <math.h>

#include <mex.h>

#include "rrtrain.h"

#include "matrixcache.h"

#define TMalloc(type,n) (type *)MALLOC((n)*sizeof(type)) 


extern "C" {
#include "mmm.h"
}



ridgereg::~ridgereg()
{
	FREE(chosenbasis);
	FREE(MemoryBlock);
}



int ridgereg::chooserow(int lastindex)
{
	int maxi=-1;
	double maxm=0;
	if( (rand()*1./RAND_MAX) > strategy)
	{	for(int i=0;i<l;i++)
		{
			if(maxm<xi[i]*xi[i])
			{
				maxm=xi[i]*xi[i];
				maxi=i;
			}

		}
		}
	else
	{
		maxi=(lastindex +1);
	}; 
	
	return maxi%l;
}

ridgereg::ridgereg(rr_problem &prob,rr_parameter &params,matrixcache & mc)
:mcache(mc),problem(prob)
{
	// init
	iteration=0;

	MemoryBlock=TMalloc(double,2*prob.l);

	chosenbasis=TMalloc(bool,prob.l);

	// initialize alpha to be 0
	alpha=MemoryBlock; memset(alpha,0,prob.l*sizeof(double));
	memset(chosenbasis,0,prob.l*sizeof(bool));

	// initialize residual vector xi to be Y
	xi=&MemoryBlock[prob.l];
	memcpy(xi,prob.y,prob.l*sizeof(double));
	epsilon=params.eps;
	
	l=prob.l;

#ifdef MEX_INFORMATION_VERSION 
	store_temporary_to_matlab=0;
	tmpArray=mxCreateDoubleMatrix(prob.l,1,mxREAL);


#endif
	
}

int ridgereg::run()
{
	double strategy=0.1;
	int result=0;
	int i=0,j=0,k=0;

	iteration = 0L;
	double alphaold;
	
	double sor=1;
	int index=0;
	
#ifdef MEX_INFORMATION_VERSION
	if(store_temporary_to_matlab)
		mexPutVariable("global","rrtrain_alpha",tmpArray);

#endif

	

	double objective=0,lastobjective=10e6;


	// if this is an hotstart we need to calculate the objective and the xi's
	for(i=0;i<l;i++)
	{
		if(fabs(alpha[i])>1e-9)
		{
			double *row=mcache.getrow(i);
			for(j=0;j<l;j++)
			{
				objective+=0.5*row[j]*alpha[i]*alpha[j];
				xi[i]-=row[j]*alpha[j];
			}
			objective-=problem.y[i]*alpha[i];
		}

	}
	info("Start Objective %f\n",objective);


	// min_a 0.5*a'*(K+ridge*eye(size(K)))*a-Y'*a

	double delta=0,deltao=0;
	double slope=10e6;double lastslope=10e6;
	int epoch=0;
	while( fabs(objective-lastobjective)>epsilon )
	{
		lastobjective=objective;
		// strategy depends on iteration
		index=chooserow(index);
		//index=iteration%l;

		double *row=mcache.getrow(index);
	
		// calculate dot product between row and xi
		double eta=0;
		for(i=0;i<l;i++) 
		{
			if(i!=index)
				eta+=row[i]*alpha[i];
		}
		
		alphaold=alpha[index];
		

		// SOR Gauss-Seidel with decreasing sor
		alpha[index]=(1-sor)*alpha[index]+ sor*(1/row[index]*(problem.y[index]-eta));
		
		// update last term
		objective-= (alpha[index]-alphaold)*problem.y[index]; 
		// update quadratic part
		//  1. update diagonal change
		objective+= 0.5*(alpha[index]*alpha[index]-alphaold*alphaold)*row[index];
		//  1. update offdiagonal changes
		for(i=0;i<index;i++)	objective+=alpha[i]*(alpha[index]-alphaold)*row[i];
		for(i=index+1;i<l;i++)	objective+=alpha[i]*(alpha[index]-alphaold)*row[i];
		
		delta+=alpha[index]-alphaold;
		deltao+=fabs(objective-lastobjective);

		
		// update residual
		for(i=0;i<l;i++)
		{
			// due to symmetry we can used the cached row	
			xi[i]-=(alpha[index]-alphaold)*row[i];
		}


	

		iteration++;
		if( (iteration % l)==0)
		{
			lastslope=slope;
			slope=deltao/fabs(delta/l);
			delta=0;			
			deltao=0;

			info("Objective: %f | E[Slope] : %f\n",objective,slope);
#ifdef MEX_INFORMATION_VERSION 
			// ----------------------------------
			// Now it is interruptable!
			mexEvalString("pause(0.01)");
			if(store_temporary_to_matlab)
			{				
				// ----------------------------------
				mexPutVariable("global","rrtrain_alpha",tmpArray);
				memcpy(mxGetPr(tmpArray),alpha,problem.l*sizeof(double));				
				// ----------------------------------
			}
#endif 
		
			if(slope>lastslope)	
			{
				info("*");

				sor=sor*0.9;
				strategy*=1.1;
				
				if ( sor<0.1) sor=0.1;
				if ( strategy>0.5) strategy=0.5;
			}		
	} 

	}


	return 1;
}













