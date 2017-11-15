
//FROM: http://local.wasp.uwa.edu.au/~pbourke/other/determinant/

#include <stdio.h>
#include <fstream.h>
#include <malloc.h>
#include <math.h>
#include <string.h>
#include <assert.h>

#include "matrices.h"
#include "lu.h"




/*
   Recursive definition of determinate using expansion by minors.
*/
double Determinant(double **a,int n)
{
   int i,j,j1,j2;
   double det = 0;
   double **m = NULL;

   if (n < 1) 
   { /* Error */

   } 
   else if (n == 1) 
   { /* Shouldn't get used */
      det = a[0][0];
   } 
   else if (n == 2) 
   {
      det = a[0][0] * a[1][1] - a[1][0] * a[0][1];
   } 
   else 
   {
      det = 0;
      for (j1=0;j1<n;j1++) 
	  {
         m = (double**)malloc((n-1)*sizeof(double *));
         for (i=0;i<n-1;i++)
            m[i] = (double*)malloc((n-1)*sizeof(double));
         for (i=1;i<n;i++) 
		 {
            j2 = 0;
            for (j=0;j<n;j++) 
			{
               if (j == j1)
                  continue;
               m[i-1][j2] = a[i][j];
               j2++;
            }
         }
         det += pow(-1.0,j1+2.0) * a[0][j1] * Determinant(m,n-1);
         for (i=0;i<n-1;i++)
            free(m[i]);
         free(m);
      }
   }
   return(det);
}

/*
   Find the cofactor matrix of a square matrix
*/
void CoFactor(double **a,int n,double **b)
{
   int i,j,ii,jj,i1,j1;
   double det;
   double **c;

   c = (double**)malloc((n-1)*sizeof(double *));
   for (i=0;i<n-1;i++)
     c[i] = (double*)malloc((n-1)*sizeof(double));

   for (j=0;j<n;j++) {
      for (i=0;i<n;i++) {

         /* Form the adjoint a_ij */
         i1 = 0;
         for (ii=0;ii<n;ii++) {
            if (ii == i)
               continue;
            j1 = 0;
            for (jj=0;jj<n;jj++) {
               if (jj == j)
                  continue;
               c[i1][j1] = a[ii][jj];
               j1++;
            }
            i1++;
         }

         /* Calculate the determinate */
         det = Determinant(c,n-1);

         /* Fill in the elements of the cofactor */
         b[i][j] = pow(-1.0,i+j+2.0) * det;
      }
   }
   for (i=0;i<n-1;i++)
      free(c[i]);
   free(c);
}

/*
   Transpose of a square matrix, do it in place
*/
void Transpose(double **a,int n)
{
   int i,j;
   double tmp;

   for (i=1;i<n;i++) {
      for (j=0;j<i;j++) {
         tmp = a[i][j];
         a[i][j] = a[j][i];
         a[j][i] = tmp;
      }
   }
}


//inverse = transpose of cofactor matrix/determinant of matrix
//place the inverse of a in inverse
void InverseMatrix(double **a,int n,double **inverse)
{
	double d = Determinant(a,n);
	if (d==0)
	{
		printf("\n.  ERROR Singular matrix...cannot take transpose");
		return;
	}

	
	CoFactor(a,n,inverse);
	Transpose(inverse,n);
	
	for (int i=0;i<n;++i)
		for (int j=0;j<n;++j)
			inverse[i][j] = inverse[i][j]/d;
}

//will find covariance between column vector col1 and column vector col2
double covariance(double **a,int col1,int col2,int TotalRows)
{
	double EX=0,EY=0,EXY=0;
	int i;

	for (i=0;i<TotalRows;++i)
	{
		EX += a[i][col1];
		EY += a[i][col2];
		EXY += a[i][col1]*a[i][col2];
	}

	EX = EX/TotalRows;
	EY = EY/TotalRows;
	EXY = EXY/TotalRows;

	return EXY - EX*EY;
}

// find covariance matrix
//given matrix a with width and height will return cov matrix in cov of size width*width
void CovarianceMatrix(double **a,int width,int height,double **cov)
{

	int i,j;
	//first fill it up with variances
	for (i=0;i<width;++i)
	{
		cov[i][i] = covariance(a,i,i,height);
		if (cov[i][i] == 0)		// we want to prevent singularity
			cov[i][i] = 1;
	}
	//now fill up with covariance
	for (i=0;i<width;++i)
	{	for (j=i+1;j<width;++j)
		{
//			cov[i][j] = covariance(a,i,j,height);
//			cov[j][i] = cov[i][j];
			cov[i][j] = 0;
			cov[j][i] = 0;
		}
	}
}



//multiply two matrices together...result in a3
//a1 is row1*col
//a2 is col*col2
//a3 will be row1*col2
void MultiplyMatrix(double **a1,double **a2,int row1,int col,int col2,double **a3)
{
	int i,j,k;

	for (i=0;i<row1;++i)
	{	
		for (j=0;j<col2;++j)
		{
			a3[i][j] = 0;

			for (k=0;k<col;++k)
			{
				a3[i][j] += a1[i][k]*a2[k][j];
			}
		}
	}

}

//multiply a vector transpose and a matrix 
//a1 is 1*col
//a2 is col*col2
//a3 is 1*col2
void MultiplyVectorTMatrix(double *a1,double **a2,int col,int col2,double *a3)
{
	int i,k;

	for (i=0;i<col2;++i)
	{	
		a3[i] = 0;
		for (k=0;k<col;++k)
		{
			a3[i] += a1[k]*a2[k][i];
		}
	}

}



void TestMatrix()
{
	int i,j;
	double temp[] = {193.9780,  -63.0913, -130.8860,  -63.0913,   21.7331,   41.3582, -130.8860,   41.3582,   89.5282};


	double **a=NULL, **b = NULL;
	AllocMatrix(&a,3,3);

	AllocMatrix(&b,3,3);

	int next=0;
	for (i=0;i<3;++i)
	{	for (j=0;j<3;++j)
		{	
			a[i][j] = temp[next];
			next++;
		}
	}

	PrintMatrix(a,3,3);
	cout << '\n';

	InverseMatrix(a,3,b);
	PrintMatrix(b,3,3);

	double d = Determinant(a,3);

	cout << "\nDeterminant = " << d;

	int success = LUDeterminant(a,3,&d);
	cout << "\n\nDeterminant = " << d << '\n';

	LUInvertMatrix(a,3,b);
	PrintMatrix(b,3,3);


	DeAllocateMatrix(a,3);
	DeAllocateMatrix(b,3);
}


//this routine will allocate memory for the arrays also
//and will read data from the .forc and data and label files
void ReadDataInMatrix(char *FileName,double ***Instances,double **Labels,int &TotalExamples,int &TotalFeatures)
{
	int j,Positive,Negative;
	double label;
	char tempString[FILE_CHAR];
	char tempFileName[FILE_CHAR];
	strcpy(tempFileName,FileName);
	strcat(tempFileName,".forc");

	//first read the parameters file
	ifstream paramStrm(tempFileName);

	paramStrm >> tempString;
	assert(!stricmp(tempString,"features"));
	paramStrm >> TotalFeatures;
	
	paramStrm >> tempString;
	assert(!stricmp(tempString,"positive"));
	paramStrm>> Positive;

	paramStrm >> tempString;
	assert(!stricmp(tempString,"negative"));
	paramStrm>> Negative;
	TotalExamples = Positive + Negative;

	//now open the data file 
	strcpy(tempFileName,FileName);
	strcat(tempFileName,".data");

	ifstream DataStrm(tempFileName);

	//now open the label file 
	strcpy(tempFileName,FileName);
	strcat(tempFileName,".labels");

	ifstream LabelStrm(tempFileName);


	//	allcoate memory for features array
	AllocMatrix(Instances,TotalExamples,TotalFeatures);
	*Labels = new double[TotalExamples];
	//now read the features

	//	now fill in the array
	int ExampleNumber = 0;
	while(true)
	{
		assert(!LabelStrm.eof());
		assert(!DataStrm.eof());
		LabelStrm >> label;
		(*Labels)[ExampleNumber] = label;
		//now read the features
		for (j=0;j<TotalFeatures;++j)
		{	
			DataStrm >> (*Instances)[ExampleNumber][j];
			
		}
		ExampleNumber++;

		if (ExampleNumber == TotalExamples)
			break;
	}

}



//void main()
//{
//	TestMatrix();
//}