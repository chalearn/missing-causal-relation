#ifndef LU_H
#define LU_H


#include <stdio.h>
#include <fstream.h>
#include <malloc.h>
#include <math.h>

#define REAL double
#define ABS(X) (((X) >= 0) ? (X) : -(X))    /* Absolute value of X */


// Invert an nxn matrix ActualMatrix using LU decomposition
//and put the values in InvertedMatrix
int LUInvertMatrix(REAL **ActualMatrix,int n,REAL **InvertedMatrix);  

//find determinant using LU decomposition
int LUDeterminant(REAL **ActualMatrix,int n,REAL *Det) ; 


#endif