/* mmm.h
 *
 * Mark's memory manager
 *
 * Defines CALLOC, MALLOC, REALLOC and FREE, which are just like the
 * standard versions, except that these do varying amounts
 * of sanity checking, depending on the value of NDEBUG.
 *
 * If NDEBUG is defined, they merely check that the memory is actually
 * allocated, and throw an error if it is not.
 *
 * If NDEBUG is not defined, then in addition they:
 *
 *  * check blocks for sanity
 *  * provide a sentinel at either end, and check that it has not been overwritten
 *  * track the number of allocated blocks and allocated bytes
 */

#ifndef _MMM_H_
#define _MMM_H_

#include <stdlib.h>



#ifdef __cplusplus
extern "C"{
#endif

extern	long	mmm_blocks_allocated;

void *mmm_calloc(size_t count, size_t size);
void *mmm_malloc(size_t n);
void *mmm_realloc(void *ptr, size_t size);
void mmm_free(void *ptr);

#define CALLOC(n,m)	mmm_calloc(n,m)
#define MALLOC(n)	mmm_malloc(n)
#define REALLOC(x,n)	mmm_realloc(x,n)
#define FREE(x)		mmm_free(x)


#ifdef __cplusplus
}
#endif

#endif