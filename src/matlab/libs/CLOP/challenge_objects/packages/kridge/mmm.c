/* mmm.c
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
 
#include "mmm.h"
#include <stdlib.h>
#include <stdio.h>

long	mmm_blocks_allocated = 0;      /* number of currently allocated blocks */

void *mmm_malloc(size_t n)
{
  register void *value = malloc(n);

  if (!value) {
    fprintf(stderr, "mmm_malloc in mmm.c: Out of memory\n");
    exit(1);
  }
  mmm_blocks_allocated++;
  return value;
}

void *mmm_calloc(size_t count, size_t size)
{
  register void *value = calloc(count, size);
  if (!value) {
    fprintf(stderr, "mmm_calloc in mmm.c: Out of memory\n");
    exit(1);
  }
  mmm_blocks_allocated++;
  return value;
}

void *mmm_realloc(void *ptr, size_t size)
{
  register void *value = realloc(ptr, size);
  if (!value) {
    fprintf(stderr, "mmm_realloc in mmm.c: Out of memory\n");
    exit(1);
  }
  
  if (!ptr)
    mmm_blocks_allocated++;

  return value;
}

void mmm_free(void *ptr)
{
	if(ptr!=NULL)
	{  free(ptr);
	  mmm_blocks_allocated--;
	}
}

