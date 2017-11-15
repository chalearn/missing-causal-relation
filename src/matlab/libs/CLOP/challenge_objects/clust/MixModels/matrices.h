//FROM: http://local.wasp.uwa.edu.au/~pbourke/other/determinant/
#ifndef MATRICES_H
#define MATRICES_H

#include <stdio.h>
#include <fstream.h>
#include <malloc.h>
#include <math.h>
#include <memory.h>

int const FILE_CHAR = 256;


//   Recursive definition of determinate using expansion by minors.
double Determinant(double **a,int n);


//   Find the cofactor matrix of a square matrix
void CoFactor(double **a,int n,double **b);

//   Transpose of a square matrix, do it in place
void Transpose(double **a,int n);


//inverse = transpose of cofactor matrix/determinant of matrix
//place the inverse of a in inverse
void InverseMatrix(double **a,int n,double **inverse);


// find covariance matrix
//given matrix a with width and height will return cov matrix in cov of size width*width
void CovarianceMatrix(double **a,int width,int height,double **cov);

//multiply two matrices together...result in a3
//a1 is row1*col
//a2 is col*col2
//a3 will be row1*col2
void MultiplyMatrix(double **a1,double **a2,int row1,int col,int col2,double **a3);

//multiply a vector transpose and a matrix 
//a1 is 1*col
//a2 is col*col2
//a3 is 1*col2
void MultiplyVectorTMatrix(double *a1,double **a2,int col,int col2,double *a3);

//test routine
void TestMatrix();

//this routine will allocate memory for the arrays also
//and will read data from the .forc and data and label files
void ReadDataInMatrix(char *FileName,double ***Instances,double **Labels,int &TotalExamples,int &TotalFeatures);




template <class T>
//allocate routine
void AllocMatrix(T ***a,int row,int col)
{
	*a = new T*[row];
	for (int i=0;i<row;++i)
		(*a)[i] = new T[col];

}
//deallocate matrix
template <class T>
void DeAllocateMatrix(T **a,int row)
{
	if (!a)		//matrix is NULL
		return;
	for (int i=0;i<row;++i)
		delete [] a[i];

	delete [] a;
}

template <class T>
void	SetVectorToVal(T *vec,int Size,T Value=0)
{
	if (Value ==0)
	{	memset(vec,(int)Value,Size*sizeof(T));
		return;
	}
	for (int i=0;i<Size;++i)
		vec[i] = Value;

}

template <class T>
void	SetMatrixToVal(T **vec,int row,int col,T Value=0)
{
	int i,j;

	for (i=0;i<row;++i)
	{	
		if (Value ==0)
		{	
			memset(vec[i],(int)Value,col*sizeof(T));
		}
		else
		{
			for (j=0;j<col;++j)
				vec[i][j] = Value;
		}
	}

}



//allocate routine for 3 dimensional matrices
template <class T>
void AllocMatrix(T ****a,int row,int col,int thirddim)
{
	int i,j;

	*a = new T**[row];
	for (i=0;i<row;++i)
	{
		(*a)[i] = new T*[col];
		for (j=0;j<col;++j)
			(*a)[i][j] = new T[thirddim];

	}

}
//deallocate matrix
template <class T>
void DeAllocateMatrix(T ***a,int row,int col)
{
	if (!a)				//matrix is NULL
		return;
	int i,j;

	for (i=0;i<row;++i)
	{	for (j=0;j<col;++j)
			delete [] a[i][j];	
	
		delete [] a[i];
	}

	delete [] a;
}


template <class T>
void CopyMatrix(T **Dest,T **Src,int row,int col)
{
	if (!Dest)		//matrix is NULL
		return;
	int i;

	for (i=0;i<row;++i)
		memcpy(Dest[i],Src[i],col*sizeof(T));
}


//print the matrix
template <class T>
void PrintMatrix(T **a,int row,int col,ofstream *pStrm=NULL)
{

	
	for (int i=0;i<row;++i)
	{
		for (int j=0;j<col;++j)
		{
			if (pStrm)
				*pStrm << a[i][j] << ' ';
			else
				cout << a[i][j] << ' ';
		}
		if (pStrm)
			*pStrm << '\n';
		else
			cout << '\n';
	}
	if (pStrm)
		pStrm->flush();
	else
		cout.flush();
}

//print the vector
template <class T>
void PrintVector(T *a,int Total,ofstream *pStrm=NULL)
{

	
	for (int i=0;i<Total;++i)
	{
		if (pStrm)
			*pStrm << a[i] << ' ';
		else
			cout << a[i] << ' ';
	}

	if (pStrm)
		pStrm->flush();
	else
		cout.flush();
}


#endif
