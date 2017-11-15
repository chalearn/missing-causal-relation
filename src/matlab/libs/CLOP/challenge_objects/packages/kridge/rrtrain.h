#ifndef _MEX_RR_
#define _MEX_RR_

#include "array.h"

class matrixcache;

extern int verbositylevel;
extern void info(char *fmt,...);

struct rr_problem
{
	int n_i,n_o;
	double *X;
	double *y;
	int l;	
};

struct rr_parameter 
{
	int rr_type;
	int kernel_type;
	double degree;
	double gamma;
	double coef0;
	double ridge;
	int cache_size;
	double eps;
	int auto_ridge;

};		// set by parse_command_line


class ridgereg
{
protected:
	double strategy;

	double *MemoryBlock;
		
#ifdef MEX_INFORMATION_VERSION 
	mxArray *tmpArray;
#endif


	matrixcache &mcache;	
	
	int l;
	rr_problem &problem;

	int chooserow(int lastindex);
	
	bool *chosenbasis;
	v_array<int> current_base;
	
	void initbase(double startrate);
	void extendbase(int extendrate);

public:

	int iteration;
	double epsilon;
	double *xi;
	double *alpha;

#ifdef MEX_INFORMATION_VERSION 
	bool store_temporary_to_matlab;
#endif


	ridgereg(rr_problem &prob,rr_parameter &params,matrixcache & mc);
	virtual ~ridgereg();

	int run();
};

#endif