/******************************************************
*                                                     *
*                  C++ version by J-P Moreau, Paris   *
* --------------------------------------------------- *
* Reference:                                          *
*                                                     *
* "Numerical Recipes by W.H. Press, B. P. Flannery,   *
*  S.A. Teukolsky and W.T. Vetterling, Cambridge      *
*  University Press, 1986".                           *
* --------------------------------------------------- *
* Modified by Mehreen to not to use the following:    * 
* basis_r.cpp and vmblock.cpp                         *
******************************************************/

#include "lu.h"
#include "matrices.h"

#define TINY 1.5e-16


   /**************************************************************
   * Given an N x N matrix A, this routine replaces it by the LU *
   * decomposition of a rowwise permutation of itself. A and N   *
   * are input. INDX is an output vector which records the row   *
   * permutation effected by the partial pivoting; D is output   *
   * as -1 or 1, depending on whether the number of row inter-   *
   * changes was even or odd, respectively. This routine is used *
   * in combination with LUBKSB to solve linear equations or to  *
   * invert a matrix. Return code is 1, if matrix is singular.   
   * VERY IMPORTANT NOTE: INDEXES START FROM 1					 *
   **************************************************************/
int LUDCMP(REAL **A, int n, int *INDX, int *d)  
{

  REAL AMAX,DUM, SUM;
  int  I,IMAX,J,K;
  REAL *VV;
//  void *vmblock = NULL; 

//  vmblock = vminit();    
//  VV      = (REAL *) vmalloc(vmblock, VEKTOR,  NMAX, 0);
  VV = new REAL[n+1];

//  if (! vmcomplete(vmblock))
//  {
//    LogError ("No Memory", 0, __FILE__, __LINE__);
//    return 1;
//  }

  *d=1; 

  for  (I=1; I<n+1; I++)  
  {
    AMAX=0.0;
    for (J=1; J<n+1; J++)  
      if (ABS(A[I][J]) > AMAX)  AMAX=ABS(A[I][J]);

    if(AMAX < TINY)  return 1;
    VV[I] = 1.0 / AMAX;
  } // i loop 

  for (J=1; J<n+1;J++)  
  {

    for (I=1; I<J; I++)  
	{ 
      SUM = A[I][J];
	  for (K=1; K<I; K++)  
        SUM = SUM - A[I][K]*A[K][J];
      A[I][J] = SUM;
	} // i loop 
    AMAX = 0.0;

	for (I=J; I<n+1; I++)  
	{
      SUM = A[I][J];
      for  (K=1; K<J; K++)  
        SUM = SUM - A[I][K]*A[K][J];
      A[I][J] = SUM;
      DUM = VV[I]*ABS(SUM);
      if (DUM >= AMAX) 
	  {
        IMAX = I;
        AMAX = DUM;
      }
	} // i loop
   
	if (J != IMAX)  
	{
	  for (K=1; K<n+1; K++)  
	  {
        DUM = A[IMAX][K];
        A[IMAX][K] = A[J][K];
        A[J][K] = DUM;
	  } // k loop 
      *d = -*d;
      VV[IMAX] = VV[J];
    }

    INDX[J] = IMAX;

    if (ABS(A[J][J]) < TINY)   
		A[J][J] = TINY;

    if (J != n)  
	{
      DUM = 1.0 / A[J][J];
      for (I=J+1; I<n+1; I++)  
        A[I][J] *= DUM;
    } 
  } // j loop 

  delete [] VV;
//  free(vmblock);
  return 0;

} // subroutine LUDCMP 


   /*****************************************************************
   * Solves the set of N linear equations A . X = B.  Here A is     *
   * input, not as the matrix A but rather as its LU decomposition, *
   * determined by the routine LUDCMP. INDX is input as the permuta-*
   * tion vector returned by LUDCMP. B is input as the right-hand   *
   * side vector B, and returns with the solution vector X. A, N and*
   * INDX are not modified by this routine and can be used for suc- *
   * cessive calls with different right-hand sides. This routine is *
   * also efficient for plain matrix inversion.                     *
   *****************************************************************/
void LUBKSB(REAL **A, int n, int *INDX, REAL *B)  {
  REAL SUM;
  int  I,II,J,LL;

  II = 0; 

  for (I=1; I<n+1; I++)  {
    LL = INDX[I];
    SUM = B[LL];
    B[LL] = B[I];
    if (II != 0) 
      for (J=II; J<I; J++)  
        SUM = SUM - A[I][J]*B[J];
    else if (SUM != 0.0)  II = I;
    B[I] = SUM;
  } // i loop

  for (I=n; I>0; I--)  {
    SUM = B[I];
    if (I < n)  {
      for (J=I+1; J<n+1; J++)
        SUM = SUM - A[I][J]*B[J];
    }
    B[I] = SUM / A[I][I];
  } // i loop 


} // LUBKSB    





// Invert an nxn matrix A using LU decomposition
//and put the values in B
int LUInvertMatrix(REAL **ActualMatrix,int n,REAL **InvertedMatrix)  
{

  REAL **A;       // matrix n+1 x n+1
  REAL *temp;     // vector n+1 
  int  *INDX,i,j;     // vector n+1 
  int d = 0;

// NOTE: index zero not used here. 

  AllocMatrix(&A,n+1,n+1);
  temp = new REAL[n+1];
  INDX = new int [n+1];

  for (i=1; i<n+1; i++)  
  {
    for (j=1; j<n+1; j++) 
	{
	  A[i][j] = ActualMatrix[i-1][j-1];
    }
  }

  //Call LU decomposition routine
  int rc = LUDCMP(A,n,INDX,&d);

  //call solver if previous return code is ok
  //to obtain inverse of A one column at a time
  if (rc==0) 
  {
	for (j=1; j<n+1; j++) 
	{
      for (i=1; i<n+1; i++) 
	  {	  if (i==j)
			temp[i]=1;
	      else
			temp[i] = 0;
	  }
      LUBKSB(A,n,INDX,temp);
      for (i=1; i<n+1; i++) 
		  InvertedMatrix[i-1][j-1]=temp[i];
    }
  }
  //the inverse matrix is now in matrix Y
  //the original matrix A is destroyed



  DeAllocateMatrix(A,n+1);

  delete [] temp;
  delete [] INDX;

  //return 0 if not successful
  if (rc==1)
  { 
	  cout << "\n  The system matrix is singular, no solution !\n";
	  return 0;
  }


  return 1;
} 

//find determinant using LU decomposition
int LUDeterminant(REAL **ActualMatrix,int n,REAL *Det)  
{

  REAL **A;       // matrix n+1 x n+1
  int  *INDX,i,j;     // vector n+1 
  int d = 0;
	
// NOTE: index zero not used here. 

  AllocMatrix(&A,n+1,n+1);
  INDX = new int [n+1];

  for (i=1; i<n+1; i++)  
  {
    for (j=1; j<n+1; j++) 
	{
	  A[i][j] = ActualMatrix[i-1][j-1];
    }
  }

  //Call LU decomposition routine
  int rc = LUDCMP(A,n,INDX,&d);

  //now get the determinant	
  if (rc==0) 
  {
      *Det = d;
    for (i=1; i<=n; i++)  
		*Det *= A[i][i];

  }




  //return 0 if not successful
  if (rc==1)
  { 
	  *Det = 0;
      cout << "\n\nSomething is wrong in getting determinant";
	  return 0;
  }
  

  delete [] INDX;

  return 1;		//successfully done
} 



// End of file inv_lu.cpp
