#ifndef _MATRIXCACHE_H_
#define _MATRIXCACHE_H_

#include "array.h"
#include "doublematrixfunctor.h"



class matrixcache:public doublematrixfunctor
{
	typedef double datatype;

	int maxrows;
	
	struct _row{
		double* row;
		short valid;
		int hit;
	};

protected:
	
	
	// Look up table for rows
	_row *cached_rows;


	

	int max_mem_consumption;
	
	
public:
	int current_mem_consumption;
	int total_cache_misses;
	int total_refills;
	
	virtual ~matrixcache();

	matrixcache(int n, int bytes);

	// indices can be swapped
	virtual double operator ()(int i, int j);

	// refill function
	double (*kernel)(int i,int j);

	double *getrow (int &i);

};


#endif