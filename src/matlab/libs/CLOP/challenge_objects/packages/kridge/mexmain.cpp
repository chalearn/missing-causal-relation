#include <stdlib.h>
#include <string.h>
#include "mexarg.h"
#include <mex.h>
#include <math.h>

#include "rrtrain.h"

char Versionstring[]="V0.1  "__DATE__;

#include "matrixcache.h"
#include "kernel.h"
#include <stdarg.h>




void printusage();



int verbositylevel;
void info(char *fmt,...)
{
	if(verbositylevel>0)
	{
		char Buffer[256];
		va_list ap;
		va_start(ap,fmt);
		vsprintf(Buffer,fmt,ap);
		va_end(ap);
		mexPrintf(Buffer);
	}
}






rr_problem prob;
rr_parameter param;




kernel *k;

double kernel_function(int i,int j)
{
	double result=0;
	result=(i==j)*param.ridge;
	result+=(*k)(i,j);
	return result;
}

extern "C"{


	void exitfcn()
	{
		info("%d Memory blocks still allocated. \n",mmm_blocks_allocated);
	}


	void mexFunction(
		int nlhs,              // Number of left hand side (output) arguments
		mxArray *plhs[],       // Array of left hand side arguments
		int nrhs,              // Number of right hand side (input) arguments
		const mxArray *prhs[]  // Array of right hand side arguments
	)
	{
		mexAtExit(exitfcn);

		mexarg arg;

		double c=0;
		char string[128]="";

		int result=1;

		verbositylevel=1;



		if (!(arg.require(nrhs,prhs,"X") & 
			arg.require(nrhs,prhs,"Y")& 
			arg.require(nrhs,prhs,"kerneltype")
			))
		{
			printusage();
		}
		else
		{
			mxArray *X;
			mxArray *Y;
			double kerneltype=0;
			double epsilon=1e-6;
			double cache=40;
			double degree=1;
			double gamma=1;
			double coef0=1;
			double auto_ridge=0;
			double ridge=1e-6;
			double safety=0;
			double verbosity=1;


			result&=arg.getmatrix(nrhs,prhs,"X",&X);
			result&=arg.getmatrix(nrhs,prhs,"Y",&Y);
			result&=arg.getscalar(nrhs,prhs,"kerneltype",&kerneltype);

			if(!arg.getscalar(nrhs,prhs,"eps",&epsilon)) epsilon=1e-6;

			if(!arg.getscalar(nrhs,prhs,"cachesize",&cache)) cache=40;
			if(!arg.getscalar(nrhs,prhs,"degree",&degree)) degree=1;
			if(!arg.getscalar(nrhs,prhs,"gamma",&gamma)) gamma=1;
			if(!arg.getscalar(nrhs,prhs,"coef0",&coef0))coef0=1;

			memset(&param,0,sizeof(param)) ;

			param.cache_size=(int)cache;
			param.eps=epsilon;
			param.coef0=coef0;
			param.gamma=gamma;
			param.degree=degree;
			param.kernel_type=(int)kerneltype;

			param.auto_ridge=0;
			if(arg.getscalar(nrhs,prhs,"auto_ridge",&auto_ridge))
				param.auto_ridge=(int)auto_ridge;

			if(!param.auto_ridge)
				if(!arg.getscalar(nrhs,prhs,"ridge",&ridge))
				{
					info("You have to specify a ridge or set auto_ridge=1.\n");
					return;
				}
				param.ridge=ridge;


				prob.l=mxGetM(X);
				prob.n_i=mxGetN(X);
				prob.n_o=mxGetN(Y);
				prob.X=mxGetPr(X);
				prob.y=mxGetPr(Y);


				switch((int)kerneltype)
				{
				case 0:k=new linearkernel(prob.X,prob.l,prob.n_i);break;
				case 1:k=new polykernel(prob.X,prob.l,prob.n_i,(int)degree,(int)coef0);break;
				case 2:k=new rbfkernel(prob.X,prob.l,prob.n_i,gamma);break;
				}

				arg.getscalar(nrhs,prhs,"safety",&safety);
				arg.getscalar(nrhs,prhs,"verbosity",&verbosity);

			

				matrixcache mcache=matrixcache(prob.l,(int)cache*1024*1024);
				mcache.kernel=kernel_function;
				
				ridgereg algo(prob,param,mcache);


				
				
				algo.store_temporary_to_matlab=safety>0;
				verbositylevel=(int)verbosity;
				info("Verbosity Level %d\n",(int)verbosity);

				mxArray *hotstartalpha;
				if(arg.getmatrix(nrhs,prhs,"alpha",&hotstartalpha))
				{
					for(int i=0;i<prob.l;i++)
						algo.alpha[i]=mxGetPr(hotstartalpha)[i];
					
					// reload cache
					for(int i=0;i<prob.l;i++)
						if(fabs(algo.alpha[i])>1e-6)
							mcache.getrow(i);
					
					info("Hotstart\n");
					
				}
				



				plhs[0]=mxCreateDoubleMatrix(prob.l,1,mxREAL);
				if(algo.run())
				{	

					double *dat=mxGetPr(plhs[0]);
					for(int i=0;i<prob.l;i++)
						dat[i]=algo.alpha[i];
					plhs[1]=mxCreateDoubleScalar(1);

				}
				else
					plhs[1]=mxCreateDoubleScalar(0);

				if(0)
				{
				plhs[2]=mxCreateDoubleMatrix(prob.l,prob.l,mxREAL);
				for(int i=0;i<prob.l;i++)
					for(int j=0;j<prob.l;j++)
						mxGetPr(plhs[2])[i*prob.l+j]=mcache.getrow(i)[j];
				}

				info("Total Cache misses : %d\n",mcache.total_cache_misses);
				info("Total Kernel Calculations: %d\n",mcache.total_refills);


		}

		info("%d Memory blocks still allocated. \n",mmm_blocks_allocated);
	}


}


void printusage()
{
	info("Spider ridge regression interface. Version : %s\n",Versionstring);
	info("Usage: [alpha,flag]=rrtrain(ARGS)\n");
	info("where Args is a list of _CELL_ array of type : { 'id', variable}\n");
	info("possible id's are: \n");
	info("{Mandatory: 'X', matrix} \t : The data matrix X.\n");
	info("{Mandatory: 'Y', vector} \t : The target vector Y.\n");
	info("{Mandatory: 'kerneltype', 0 OR 1 OR 2} \t : The used kernel: 0-linear, 1-poly, 2-rbf.\n");
	info("{Mandatory: 'ridge', scalar>0} \t : The used ridge value.\n");
	info("{Optional:  'eps', scalar>0} \t : The used accuracy for comparing changes in the objective function.\n");
	info("{Optional:  'cachesize', scalar>1} \t : The used number of MB for caching.\n");
	info("{Optional:  'degree', scalar>1} \t : The used degree for the poly kernel: (x'*y +c)^!d!.\n");
	info("{Optional:  'coef0', scalar>0} \t : The used coefficient for the poly kernel: (x'*y +!c!)^d.\n");
	info("{Optional:  'gamma', scalar>0} \t : The used coefficient for the rbf kernel: exp(-gamma*||x-y||^2).\n");
	info("{Optional:  'verbosity', 0 or 1} \t : Switches on/off messages while optimization.\n");
	info("{Optional:  'safety', 0 or 1} \t : This switch forces to store intermediate solution vector to the\n");
	info("                                   variable [rrtrain_alpha] in Matlabs *global* workspace\n");
	info("{Optional:  'alpha', vector} \t : If this vector provided then the solver performs a hot start. \n");
		return;


}