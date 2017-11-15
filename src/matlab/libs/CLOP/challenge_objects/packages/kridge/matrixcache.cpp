#include "matrixcache.h"
#include <assert.h>
#include <memory.h>
#include <mex.h>

#include <stdio.h>

template<class T> void swap(T&x,T&y){ T t;t=y;y=x;x=t; } 



matrixcache::~matrixcache()
{
	int i=0;
	for(i=0;i<maxrows;i++)
	{
		if(cached_rows[i].valid)
			FREE(cached_rows[i].row);
	}
	FREE(cached_rows);
}	

matrixcache::matrixcache(int n, int bytes)
{
	// set minimum number of bytes to something reasonable
	// store ate least 2 rows.	
	if(bytes< n*sizeof(double)*2+2*sizeof(_row))
		bytes=n*sizeof(double)*2+2*sizeof(_row);
	
	maxrows=n;
	max_mem_consumption=bytes;	
	cached_rows=(_row*)MALLOC(sizeof(_row)*maxrows);
	memset(cached_rows,0,sizeof(_row)*maxrows);
	total_cache_misses=0;total_refills=0;
	current_mem_consumption=maxrows*sizeof(_row);	
}



double matrixcache::operator()(int i, int j)
{	
	
	return getrow(i)[j];
}

double *matrixcache::getrow (int &row_index)
{
	if(!cached_rows[row_index].valid)
	{
		// refile

		if( current_mem_consumption+maxrows*sizeof(double) < max_mem_consumption)
		{
			// that is great! we can just compute this beast and add it to the cache. 
			
			cached_rows[row_index].row=(double*) MALLOC( maxrows * sizeof(double));
			current_mem_consumption+=maxrows * sizeof(double);
			
			for(int j=0;j<maxrows;j++)
				cached_rows[row_index].row[j]=kernel(row_index,j),total_refills++;
			
			cached_rows[row_index].valid=true;
			cached_rows[row_index].hit=0;

		}
		else
		{

			total_cache_misses++;
			
			//mexPrintf("Cache Misses=%d \n",total_cache_misses);

			int smallest_hit_i=-1;
			int smallest_hit=0;
			// need to unfile one and refile  with the newest one.
			// potential bug: if cachesize==0 
			for(int i=0;i<maxrows;i++)
			{
				if(cached_rows[i].valid)
				if(smallest_hit<cached_rows[i].hit)
				{
					smallest_hit=cached_rows[i].hit;
					smallest_hit_i=i;
				}
			}

			

			if(cached_rows[smallest_hit_i].valid)
			{
				cached_rows[row_index].row=cached_rows[smallest_hit_i].row;
				cached_rows[smallest_hit_i].row=NULL;
				cached_rows[smallest_hit_i].valid=false;
				cached_rows[smallest_hit_i].hit=0;
				cached_rows[row_index].valid=true;
				cached_rows[row_index].hit=0;

				// fill up
				for(int j=0;j<maxrows;j++)
					cached_rows[row_index].row[j]=kernel(row_index,j),total_refills++;
			
			//	mexPrintf("Refiled %d \n",smallest_hit_i);

			}
			else
				throw;
				

		}

	}

	cached_rows[row_index].hit++;
	return cached_rows[row_index].row;
}
