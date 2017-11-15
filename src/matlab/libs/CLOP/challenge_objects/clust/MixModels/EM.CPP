//CODE by mehreen saeed, FAST National University of Computer and Emerging Sciences
//Lahore Pakistan.  mehreen.saeed@nu.edu.pk mehreen.mehreen@gmail.com

#include <fstream.h>
#include <assert.h>
#include <string.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "lu.h"
#include "matrices.h"
#include "em.h"
#include "remsparse.h"
#include "rem.h"


#define DELETEOBJ(obj){if (obj) delete [] obj;obj=NULL;} 



EM::EM(int TotalMixtures)
{
	m_Prob = NULL;
	m_Features = NULL;
	m_Cov = NULL;
	m_InvCov = NULL;
	m_Mean = NULL;
	m_Z = NULL;
	m_Prior = NULL;
	m_SumZ = NULL;
	m_TotalExamples = 0;
	m_TotalFeatures = 0;
	m_TotalMixtures = TotalMixtures;
	m_Determinant = NULL;
	m_ModelType = GAUSSIAN;
	m_UseLogProb = false;
}

//TODO: DELETE MEMORY HERE
EM::~EM()
{
	DeAllocateMatrix(m_Features,m_TotalExamples);
	DeAllocateMatrix(m_Cov,m_TotalMixtures,m_TotalFeatures);
	DeAllocateMatrix(m_InvCov,m_TotalMixtures,m_TotalFeatures);
	DeAllocateMatrix(m_Mean,m_TotalMixtures);
	DeAllocateMatrix(m_Z,m_TotalExamples);
	DeAllocateMatrix(m_Prob,m_TotalMixtures);
	DELETEOBJ(m_Prior)
	DELETEOBJ(m_SumZ);
	DELETEOBJ(m_Determinant);
}

void EM::SetModel(tModelType ModelType)
{
	m_ModelType = ModelType;
}



//will return 0 if a singularity detected
//will set all the inverse covariance matrices and determinants
int EM::SetInvCovAndDet()
{
	int i;
	int result = 1;
	for (i=0;i<m_TotalMixtures;++i)
	{	
		result = result & LUInvertMatrix(m_Cov[i],m_TotalFeatures,m_InvCov[i]);
		LUDeterminant(m_Cov[i],m_TotalFeatures,&m_Determinant[i]);
		assert(result != 0);
	}

	return result;
}

//initialize to actual covariance matrix and inbetween means
void EM::Initialize()
{

	//initialize the zij i.e the hidden variables
	AllocMatrix(&m_Z,m_TotalExamples,m_TotalMixtures);

	//initialize the prior's memory and set them to 1/TotalMixtures
	m_Prior = new double[m_TotalMixtures];
	SetVectorToVal(m_Prior,m_TotalMixtures,(double)1/(double)m_TotalMixtures);
	
	//initialize m_SumZ
	m_SumZ = new double[m_TotalMixtures];
	SetVectorToVal(m_SumZ,m_TotalMixtures);

	if (m_ModelType == BERNOULLI)
	{
		InitializeBernoulli();
		return;
	}

	if (m_ModelType == BINOMIAL)
	{
		InitializeBinomial();
		return;
	}


	//The rest of initializations are required for gaussian models
	int i,j,Example,result;

	//initialize the covariance & its inverse & determinants
	
	AllocMatrix(&m_Cov,m_TotalMixtures,m_TotalFeatures,m_TotalFeatures);
	AllocMatrix(&m_InvCov,m_TotalMixtures,m_TotalFeatures,m_TotalFeatures);
	m_Determinant = new double[m_TotalMixtures];

	//find the zeroth covariance matrix from data
	CovarianceMatrix(m_Features,m_TotalFeatures,m_TotalExamples,m_Cov[0]);
	//set the rest of cov matrices to same values
	for (i=1;i<m_TotalMixtures;++i)
		CopyMatrix(m_Cov[i],m_Cov[0],m_TotalFeatures,m_TotalFeatures);

	//set the inverse matrix and determinants matrix
	result = SetInvCovAndDet();
	//now make sure thea cov matrices is not singular

	if (result == 0)		//means we have singular matrix
	{
		cout << "\n\n ... We have a singular matrix";
		exit(0);
		return;
	}

	//initialize m_means
	AllocMatrix(&m_Mean,m_TotalMixtures,m_TotalFeatures);


	//initalize the m_Means to some values
	for (i=0;i<m_TotalMixtures;++i)
	{	
		Example = m_TotalExamples/m_TotalMixtures*i;
		for (j=0;j<m_TotalFeatures;++j)
		{
			m_Mean[i][j] = m_Features[Example][j];
		}
	}

}


double EM::CalcProbability(int Row,int MixNumber)
{
	switch (m_ModelType)
	{
		case GAUSSIAN:
			return CalcGaussian(Row,MixNumber);
		case BERNOULLI:
			return CalcBernoulli(Row,MixNumber);
		case BINOMIAL:
			return CalcBinomial(Row,MixNumber);

		default:
			assert(false);
	}
	return 0;
}


double EM::CalcProbability(double *Instance,int MixNumber)
{
	switch (m_ModelType)
	{
		case GAUSSIAN:
			assert(false);
//			return CalcGaussian(Instance,MixNumber);
		case BERNOULLI:
			return CalcBernoulli(Instance,MixNumber);
		case BINOMIAL:
			return CalcBinomial(Instance,MixNumber);

		default:
			assert(false);
	}
	return 0;
}


//calculate the Gaussian
double EM::CalcGaussian(int Row,int MixNumber)
{
	int i;
	double *diff = new double[m_TotalFeatures];
	double *temp = new double[m_TotalFeatures];
	double exponent=0;

   //calc diff of mean	matrix
	for (i=0;i<m_TotalFeatures;++i)
		diff[i] = m_Features[Row][i] - m_Mean[MixNumber][i];

	MultiplyVectorTMatrix(diff,m_InvCov[MixNumber],m_TotalFeatures,m_TotalFeatures,temp);

	for (i=0;i<m_TotalFeatures;++i)
		exponent += diff[i]*temp[i];

	exponent = exponent*(-0.5);
	assert(exponent <= 0);

	exponent = exp(exponent);

	assert(exponent >= 0);

	exponent = exponent*1/sqrt(m_Determinant[MixNumber]);

	delete [] diff;
	delete [] temp;

//	return temp2*exponent;
	return exponent;
}




//calculate the zij
void EM::EStep()
{
	//do the Estep if using log prob separately
	if (m_UseLogProb)
	{
		EM::EStepWithLog();
		return;
	}

	int i,j;

	//this is temporary
	double *RowZ = new double[m_TotalMixtures];
	//this is sum of denominator
	double Sum=0;
	
	SetVectorToVal(m_SumZ,m_TotalMixtures);

	for (i=0;i<m_TotalExamples;++i)
	{
		Sum = 0;

		//calc numerator with prob of all gaussians
		for (j=0;j<m_TotalMixtures;++j)
		{	
			RowZ[j] = m_Prior[j]*CalcProbability(i,j);
			Sum += RowZ[j];
		}
		//assert(Sum != 0);

		//now divide numerator by denominator
		//and also update m_SumZ
		for (j=0;j<m_TotalMixtures;++j)
		{	
			if (Sum != 0)
				m_Z[i][j] = RowZ[j]/Sum;
			else
				m_Z[i][j] = 0;

		    m_SumZ[j] += m_Z[i][j];
			assert(m_Z[i][j] >= 0 && m_Z[i][j] <= 1);
		}
	}


//	ofstream Strm("tmp.txt",ios::app);

//	Strm << "\n\n Next iteration " <<"\n";
//	PrintMatrix(m_Z,m_TotalExamples,m_TotalMixtures,&Strm);
	
//	Strm << "\n\n The sums " <<"\n";

//	PrintVector(m_SumZ,m_TotalMixtures,&Strm);

	delete [] RowZ;
}


//calculate the zij
void EM::EStepWithLog()
{

	int i,j;

	//this is temporary
	double *RowZ = new double[m_TotalMixtures];
	//this is sum of denominator
	double Sum=0;
	//this is the min value of all numerators in a row
	double max=-1000000.0;
	
	SetVectorToVal(m_SumZ,m_TotalMixtures);

	for (i=0;i<m_TotalExamples;++i)
	{
		Sum = 0;
		max = -1000000.0;
		//calc numerator with prob of all mixtures
		//since we are using log prob we will use the log of priors also
		for (j=0;j<m_TotalMixtures;++j)
		{	
			RowZ[j] = log10(m_Prior[j])+CalcProbability(i,j);
			if (RowZ[j] > max)
				max = RowZ[j];
		}
		assert(max < 0);
		//now bring the prob back to antilog scale by subtracting the min from them
		for (j=0;j<m_TotalMixtures;++j)
		{
			RowZ[j] = RowZ[j] - max;		//this will bring it down to a reasonable scale
											//and so we can take the antilog now
			if (RowZ[j] < -300)				//this will keep us away from floating pt underflow
				RowZ[j] = 10E-300;
			else
				RowZ[j] = powl(LOGBASE,RowZ[j]);
			Sum += RowZ[j];
		}

		//now divide numerator by denominator
		//and also update m_SumZ
		for (j=0;j<m_TotalMixtures;++j)
		{	m_Z[i][j] = RowZ[j]/Sum;
		    m_SumZ[j] += m_Z[i][j];
			assert(m_Z[i][j] >= 0 && m_Z[i][j] <= 1);
			assert(m_SumZ[j] > 0);
		}

	}

	delete [] RowZ;
}




//update the means
void EM::UpdateMeans()
{

	int i,j,k;
	double *Numerator=0;

	Numerator = new double[m_TotalFeatures];
	for (j=0;j<m_TotalMixtures;++j)
	{
		for (k=0;k<m_TotalFeatures;++k)
			Numerator[k] = 0;

		for (i=0;i<m_TotalExamples;++i)
		{

			for (k=0;k<m_TotalFeatures;++k)
			{
				Numerator[k]+=m_Features[i][k]*m_Z[i][j];
			}
		}


		for (k=0;k<m_TotalFeatures;++k)
			m_Mean[j][k] = Numerator[k]/m_SumZ[j];
	}

	delete [] Numerator;
}

void EM::UpdatePriors()
{
	int j;

	for (j=0;j<m_TotalMixtures;++j)
	{
		m_Prior[j] = m_SumZ[j]/m_TotalExamples;
	}
}

//simply apply the formula here
void EM::UpdateCovrianceMatrices()
{
	int i,j,k,m,f;
	double *Diff = new double[m_TotalFeatures];

	
	for (j=0;j<m_TotalMixtures;++j)
	{
		//initialize the covariance matrix
		SetMatrixToVal(m_Cov[j],m_TotalFeatures,m_TotalFeatures);
		for (i=0;i<m_TotalExamples;++i)
		{
			//this is the difference b/w data point and mean 
			for (f=0;f<m_TotalFeatures;++f)
				Diff[f] = m_Features[i][f] - m_Mean[j][f];
			//now re-calc cov matrix
			for (k=0;k<m_TotalFeatures;++k)
			{
				//	for (m=0;m<m_TotalFeatures;++m)
				//get a diagonal matrix only
				m=k;
				{
					m_Cov[j][k][m] += m_Z[i][j]*Diff[k]*Diff[m];
				}
			}
		}
		//now average over sums of zijs
		for (k=0;k<m_TotalFeatures;++k)
		{	//for (m=0;m<m_TotalFeatures;++m)
			//we are using only diagonal matrices
			m = k;
			{	
				m_Cov[j][k][m] = m_Cov[j][k][m]/m_SumZ[j];
				if (m_Cov[j][k][m] <= 1e-5)	//this to prevent singularity
					m_Cov[j][k][m] = 1;
			}
		}
	}

	delete [] Diff;


	//the last thing to do is to upate the inverse cov and determinants
	if (!SetInvCovAndDet())
	{
		assert(false);
		printf("\n....we have a singularity");
		return;
	}
}

void EM::MStep()
{
	if (m_ModelType == GAUSSIAN)
	{
		UpdatePriors();
		UpdateMeans();
		UpdateCovrianceMatrices();
		return;
	}
	if (m_ModelType == BERNOULLI)
	{
		UpdatePriors();
		UpdateBernoulliProb();
		return;
	}

	if (m_ModelType == BINOMIAL)
	{
		UpdatePriors();
		UpdateBinomialProb();
	}

}
//--------------------------------------------------------------------

//initialize for bernoulli distribution
//initialize the probabilities here
void EM::InitializeBernoulli()
{
	int i,j;
	unsigned char temp;
	//initialize m_Prob
	AllocMatrix(&m_Prob,m_TotalMixtures,m_TotalFeatures);

	if (m_AddSeed)
		srand( (int)m_AddSeed );
//	else
//		srand( (unsigned)time( NULL ));

	//initalize the m_Prob to some random values
	for (i=0;i<m_TotalMixtures;++i)
	{	
		

//		Example = m_TotalExamples/m_TotalMixtures*i;
		for (j=0;j<m_TotalFeatures;++j)
		{ 
//			m_Prob[i][j] = m_Features[Example][j];
			//we'll store the random value in a character variable
			temp = (unsigned char) rand() | 1;
			m_Prob[i][j] = (double)temp/(BYTE_MAXI+1);
			assert(m_Prob[i][j] != 1);
			assert(m_Prob[i][j]!=0);
		}
	}

//	gAddSeed += 10;

/*	//initalize the prob equally spaced
	double prob;
	for (i=0;i<m_TotalMixtures;++i)
	{	
		if (m_TotalMixtures == 1)
			prob = 0.5;
		else
			prob = .90/(double)(m_TotalMixtures-1)*i+.05;
		for (j=0;j<m_TotalFeatures;++j)
		{ 
			m_Prob[i][j] = prob;
			assert(m_Prob[i][j] != 1);
			assert(m_Prob[i][j]!=0);
		}
	}

*/

}




//calculate probability for bernoulli
//we'll calculate the prob here and multiply them with SCALE factor everytime to keep the
//scale right
//or just simply use log prob
double EM::CalcBernoulli(int Row,int MixNumber)
{

	int i;
	double Sum=1;

	//not using log prob
	if (!m_UseLogProb)
	{
		for (i=0;i<m_TotalFeatures;++i)
		{
			if (m_Features[Row][i])
				Sum *= m_Prob[MixNumber][i] * SCALE;
			else
				Sum *= (1-m_Prob[MixNumber][i]) * SCALE;
		}
	}

	else //using log prob
	{
		Sum = 0;
		for (i=0;i<m_TotalFeatures;++i)
		{
			assert(m_Prob[MixNumber][i]!=0);
			assert(m_Prob[MixNumber][i]!=1);

			if (m_Features[Row][i])
				Sum += log10(m_Prob[MixNumber][i]) ;
			else
				Sum += log10(1-m_Prob[MixNumber][i]) ;
		}

	}

	return Sum;
}





//calculate probability for binomial
//we'll calculate the prob here and multiply them with SCALE factor everytime to keep the
//scale right
//or just simply use log prob
double EM::CalcBernoulli(double *Instance,int MixNumber)
{

	int i;
	double Sum=1;

	//not using log prob
	if (!m_UseLogProb)
	{
		for (i=0;i<m_TotalFeatures;++i)
		{
			if (Instance[i])
				Sum *= m_Prob[MixNumber][i] * SCALE;
			else
				Sum *= (1-m_Prob[MixNumber][i]) * SCALE;
		}
	}

	else //using log prob
	{
		Sum = 0;
		for (i=0;i<m_TotalFeatures;++i)
		{
			assert(m_Prob[MixNumber][i]!=0);
			assert(m_Prob[MixNumber][i]!=1);

			if (Instance[i])
				Sum += log10(m_Prob[MixNumber][i]) ;
			else
				Sum += log10(1-m_Prob[MixNumber][i]) ;
		}

	}

	return Sum;
}



//update the probability parameter
void EM::UpdateBernoulliProb()
{
	int i,j,m;
	double numerator=0;
	for (m=0;m<m_TotalMixtures;++m)
	{

		for (j=0;j<m_TotalFeatures;++j)
		{
			numerator = 0;
			//sum only the zij for which xij is one...we can optimise this later...TBD
			for (i=0;i<m_TotalExamples;++i)
			{
				
				if (m_Features[i][j])
					numerator += m_Z[i][m];
			}
			//now the new probability..use Laplacian prior to smooth
			m_Prob[m][j] = (1+numerator)/(2+m_SumZ[m]);
			
/*			m_Prob[m][j] = (numerator)/(m_SumZ[m]);
			if (m_Prob[m][j] == 0)
				m_Prob[m][j] = 0.03;
			if (m_Prob[m][j] == 1)
				m_Prob[m][j] = 0.97;
*/

			assert(m_Prob[m][j]>0 && m_Prob[m][j]<1);


		}
	}
}


void EM::WriteProb(char *FileName)
{
	ofstream Stream(FileName,ios::app);


	PrintMatrix(m_Prob,m_TotalMixtures,m_TotalFeatures,&Stream);

}

//write the probability of individual instances to a file
void EM::WriteInstanceProb(char *FileName,EM *pClass2EM/*=NULL*/)
{
	ofstream Stream(FileName);
	int i,Mix;
	
	for (i=0;i<m_TotalExamples;++i)
	{
		for (Mix=0;Mix<m_TotalMixtures;++Mix)
			Stream << CalcProbability(m_Features[i],Mix) << ' ';

		if (pClass2EM)
		{
			for (Mix=0;Mix < pClass2EM->m_TotalMixtures;++Mix)
				Stream << pClass2EM->CalcProbability(m_Features[i],Mix) << ' ';
		}

		Stream << '\n';
	}
}


//write the probability of individual instances to a file
void EM::WriteInstanceProb(char *FileName,double **Instances,int row,int col,EM *pClass2EM/*=NULL*/)
{
	ofstream Stream(FileName);
	int i,Mix;
	assert(col == m_TotalFeatures);

	for (i=0;i<row;++i)
	{
		for (Mix=0;Mix<m_TotalMixtures;++Mix)
			Stream << CalcProbability(Instances[i],Mix) << ' ';
		if (pClass2EM)
		{
			for (Mix=0;Mix < pClass2EM->m_TotalMixtures;++Mix)
				Stream << pClass2EM->CalcProbability(Instances[i],Mix) << ' ';
		}
		Stream << '\n';
	}
}


//----------------------------------------------------------------------
double EM::Distance(int MixIndex,int ExampleIndex)
{
	double distance=0,diff=0;
	for (int i=0;i<m_TotalFeatures;++i)
	{
		diff = m_Features[ExampleIndex][i]-m_Mean[MixIndex][i];
		distance += (diff)*(diff);
	}
	return distance;


	double prob = -1;
}

int EM::ClassifyOnDistance(int ExampleIndex)
{

	double Min=Distance(0,ExampleIndex);
	int MinIndex = 0,i;
	double d;

	for (i=1;i<m_TotalMixtures;++i)
	{
		d = Distance(i,ExampleIndex);
		if (d<Min)
		{	MinIndex = i;
			Min = d;	
		}
	}

	return MinIndex;
}


//suppose we also want the prob returned then it will go in the second var
int EM::ClassifyOnProb(int ExampleIndex,double *pMaxProb/*=NULL*/)
{

	double Max=CalcProbability(ExampleIndex,0);
	int MaxIndex = 0,i;
	double prob;

	for (i=1;i<m_TotalMixtures;++i)
	{
		prob = CalcProbability(ExampleIndex,i);
		if (prob > Max)
		{	MaxIndex = i;
			Max = prob;	
		}
	}

	if (pMaxProb)
		*pMaxProb = Max;
	return MaxIndex;
}

//suppose we want to classify an instance
//suppose we also want the prob returned then it will go in the second var
int EM::ClassifyOnProb(double *TestInstance,double *pMaxProb/*=NULL*/)
{

	double Max=CalcProbability(TestInstance,0);
	int MaxIndex = 0,i;
	double prob;

	for (i=1;i<m_TotalMixtures;++i)
	{
		prob = CalcProbability(TestInstance,i);
		if (prob > Max)
		{	MaxIndex = i;
			Max = prob;	
		}
	}

	if (pMaxProb)
		*pMaxProb = Max;
	return MaxIndex;
}

//---------------------------------------------------------------------------------------
//initialize for binomal distribution
//initialize the probabilities here
void EM::InitializeBinomial()
{
	int i,j;
	unsigned char temp;
	//initialize m_Prob
	AllocMatrix(&m_Prob,m_TotalMixtures,m_TotalFeatures);

	//initalize the m_Prob to some random values
	for (i=0;i<m_TotalMixtures;++i)
	{	
		for (j=0;j<m_TotalFeatures;++j)
		{ 
			//we'll store the random value in a character variable
			temp = (unsigned char) rand() | 1;
			m_Prob[i][j] = (double)temp/(BYTE_MAXI+1);
			assert(m_Prob[i][j] != 1);
			assert(m_Prob[i][j]!=0);
		}
	}

}



//for binomials
//calculate the prob for binomial
//actually this is multinomial dist
//as the factorial terms cancel out we don't calc them here
double EM::CalcBinomial(int Row,int MixNumber)
{

	int i;
	double Sum=0;

	assert(m_UseLogProb);

	for (i=0;i<m_TotalFeatures;++i)
	{
		assert(m_Prob[MixNumber][i]!=0);
		assert(m_Prob[MixNumber][i]!=1);

		if (m_Features[Row][MixNumber])
			Sum += m_Features[Row][MixNumber]*log10(m_Prob[MixNumber][i]) ;
	}

	return Sum;
}

//calculate probability for binomial
//use only with log prob
double EM::CalcBinomial(double *Instance,int MixNumber)
{

	int i;
	double Sum=0;

	assert (m_UseLogProb);
	Sum = 0;
	for (i=0;i<m_TotalFeatures;++i)
	{
		assert(m_Prob[MixNumber][i]!=0);
		assert(m_Prob[MixNumber][i]!=1);

		if (Instance[i])
			Sum += Instance[i]*log10(m_Prob[MixNumber][i]) ;
	}

	return Sum;
}

//update the probability parameter
void EM::UpdateBinomialProb()
{
	int i,f,m;
	double numerator=0;
	double denominator=0;

	SetMatrixToVal(m_Prob,m_TotalMixtures,m_TotalFeatures);

	for (m=0;m<m_TotalMixtures;++m)
	{
		denominator = 0;
		//move row wise for a feature
		for (f=0;f<m_TotalFeatures;++f)
		{
			for (i=0;i<m_TotalExamples;++i)
			{
				if (m_Features[i][f])
					m_Prob[m][f] += m_Z[i][m]*m_Features[i][f];
			}
			denominator += m_Prob[m][f];
		}
		for (f = 0;f<m_TotalFeatures;++f)
		{
			m_Prob[m][f] = (m_Prob[m][f]+1.0)/(denominator+m_TotalFeatures);  //do with laplace smoothing
			assert(m_Prob[m][f]>0 && m_Prob[m][f]<1);

		}
	}
}


//--------------------------------------------------------------------------------------------
//Implementation of DataEM
//--------------------------------------------------------------------------------------------
DataEM::DataEM(int TotalClusters,tExampleType et/*=POSITIVE*/,tModelType mt /*= BERNOULLI*/)
{
	m_TotalMixtures = TotalClusters;
	m_ExampleType = et;
	m_ModelType = mt;
	if (m_ModelType == BERNOULLI || m_ModelType == BINOMIAL)
		m_UseLogProb = true;

}
//this routine will set the input matrix for EM
void DataEM::SetDataMatrix(double **InputMatrix,int rows,int cols)
{
	m_TotalFeatures = cols;
	m_TotalExamples = rows;

	//	allcoate memory for features array
	AllocMatrix(&m_Features,m_TotalExamples,m_TotalFeatures);
	
	//copy this matrix onto the features matrix
	CopyMatrix(m_Features,InputMatrix,rows,cols);
}

//this routine will read data from a file
void DataEM::ReadData(char *FileName)
{
	int discarded,j,label;
	char tempString[FILE_CHAR];
	char tempFileName[FILE_CHAR];
	strcpy(tempFileName,FileName);
	strcat(tempFileName,".forc");

	//first read the parameters file
	ifstream paramStrm(tempFileName);

	paramStrm >> tempString;
	assert(!stricmp(tempString,"features"));
	paramStrm >> m_TotalFeatures;
	
	paramStrm >> tempString;
	assert(!stricmp(tempString,"positive"));
	paramStrm>> m_TotalExamples;

	paramStrm >> tempString;
	assert(!stricmp(tempString,"negative"));
	if (m_ExampleType == NEGATIVE)
		paramStrm>> m_TotalExamples;

	//now open the data file 
	strcpy(tempFileName,FileName);
	strcat(tempFileName,".data");

	ifstream DataStrm(tempFileName);

	//now open the label file 
	strcpy(tempFileName,FileName);
	strcat(tempFileName,".labels");

	ifstream LabelStrm(tempFileName);


	//	allcoate memory for features array
	AllocMatrix(&m_Features,m_TotalExamples,m_TotalFeatures);
	//now read the features

	//	now fill in the array
	int ExampleNumber = 0;
	while(true)
	{
		assert(!LabelStrm.eof());
		assert(!DataStrm.eof());
		LabelStrm >> label;
		if ((label == POSITIVE_LABEL && m_ExampleType == POSITIVE) ||
			(label == NEGATIVE_LABEL && m_ExampleType == NEGATIVE) )
		{
			//now read the features
			for (j=0;j<m_TotalFeatures;++j)
			{	
				DataStrm >> m_Features[ExampleNumber][j];
				m_Features[ExampleNumber][j] *= 1;
			}
			ExampleNumber++;
		}
		else
			for (j=0;j<m_TotalFeatures;++j)
				DataStrm >> discarded;

		if (ExampleNumber == m_TotalExamples)
			break;
	}
//	PrintMatrix(m_Features,m_TotalExamples,m_TotalFeatures);

}

//this routine will read data from a file
void DataEM::ReadSparseData(char *FileName)
{
	int label;
	char tempString[FILE_CHAR];
	char tempFileName[FILE_CHAR];
	strcpy(tempFileName,FileName);
	strcat(tempFileName,".forc");

	//first read the parameters file
	ifstream paramStrm(tempFileName);

	paramStrm >> tempString;
	assert(!stricmp(tempString,"features"));
	paramStrm >> m_TotalFeatures;
	
	paramStrm >> tempString;
	assert(!stricmp(tempString,"positive"));
	paramStrm>> m_TotalExamples;

	paramStrm >> tempString;
	assert(!stricmp(tempString,"negative"));
	if (m_ExampleType == NEGATIVE)
		paramStrm>> m_TotalExamples;

	//now open the data file 
	strcpy(tempFileName,FileName);
	strcat(tempFileName,".data");

	ifstream DataStrm(tempFileName);

	//now open the label file 
	strcpy(tempFileName,FileName);
	strcat(tempFileName,".labels");

	ifstream LabelStrm(tempFileName);


	//	allcoate memory for features array
	AllocMatrix(&m_Features,m_TotalExamples,m_TotalFeatures);
	SetMatrixToVal(m_Features,m_TotalExamples,m_TotalFeatures);

	int ExampleNumber = 0;
	int index,line=0;
	char temp[10001],s;
	temp[0] = 0;
	while(true)
	{
		assert(!LabelStrm.eof());
		assert(!DataStrm.eof());
		LabelStrm >> label;
		if ((label == POSITIVE_LABEL && m_ExampleType == POSITIVE) ||
			(label == NEGATIVE_LABEL && m_ExampleType == NEGATIVE) )
		{
			s = DataStrm.peek();
			if (s!='\n') 
				s = 0;
			else
				s = DataStrm.get();
			while(s!='\n'&&s!=-1)
			{
				if (s!=0)
					DataStrm.putback(s);
				DataStrm >> index;
				assert(index <= m_TotalFeatures);
				m_Features[ExampleNumber][index-1] = 1;
				s= DataStrm.peek();
				while (s==' ') s = DataStrm.get();
				if (s==-1)
					cout << s;
				
			}
			ExampleNumber++;
		}
		else
			DataStrm.getline(temp,10000,'\n');
		if (strlen(temp) == 0)
			cout << line << '\n';
		line++;	
		if (ExampleNumber == m_TotalExamples)
			break;
	}

}



//Get overall prob of the class
//will return log of prob of class
double DataEM::ProbOfClass(double *Instance)
{

	assert(m_UseLogProb);
	int i;
	double TotalProb = 0; 
	double *ProbArray = new double[m_TotalMixtures];
	double MaxScale=-10000000;

	for (i=0;i<m_TotalMixtures;++i)
	{	
		//prob multiplied by the prior of the
		ProbArray[i] = CalcProbability(Instance,i) + log10(m_Prior[i]);
		if (ProbArray[i] > MaxScale)
			MaxScale = ProbArray[i];
	}
	for (i=0;i<m_TotalMixtures;++i)
	{
		ProbArray[i] = ProbArray[i] - MaxScale;
		if (ProbArray[i] < -300)
			ProbArray[i] = 0;
		else
			ProbArray[i] = pow(LOGBASE,ProbArray[i]);	//bring it to absolute scale

		TotalProb += ProbArray[i];
		assert(TotalProb <= 1e307 && TotalProb >= 0);
	}

	
	//now bring prob to log scale
	TotalProb = log10(TotalProb);
	TotalProb = TotalProb + MaxScale;
	
	delete [] ProbArray;
	return TotalProb;

}

//we have mixtures of different classes passed here
//later we can extend it to include other classes too
//will return %correct on this data
double DataEM::TestTrainData(EM &emClass1)
{
	int i,Classification;
	double prob1,prob2;
	int Correct = 0;

	//for each instance
	for (i=0;i<m_TotalExamples;++i)
	{

		Classification = ClassifyOnProb(i,&prob1);
		//now classify with the other class
		Classification = emClass1.ClassifyOnProb(m_Features[i],&prob2);
		//if prob2 > prob1 then incorrect class
		if (prob1>prob2)
			Correct++;
	}
	return (double)Correct/(double)m_TotalExamples*100.0;
}

//here classify according to the overall prob of class
double DataEM::TestTrainData1(DataEM &emClass1)
{
	int i;
	double prob1,prob2,LogClassProb1,LogClassProb2;
	int Correct = 0,TotalExamples;

	assert(m_UseLogProb);
	//first lets calc the prior of each class as we have to apply Baye's theorem here
	TotalExamples = m_TotalExamples+emClass1.m_TotalExamples;
	LogClassProb1 = log10((double)m_TotalExamples/(double)TotalExamples);
	LogClassProb2 = log10((double)emClass1.m_TotalExamples/(double)TotalExamples);

	//for each instance
	for (i=0;i<m_TotalExamples;++i)
	{


		prob1 = LogClassProb1+ProbOfClass(m_Features[i]);
		//now classify with the other class
		prob2 = LogClassProb2+emClass1.ProbOfClass(m_Features[i]);
		//if prob2 > prob1 then incorrect class
		if (prob1>prob2)
			Correct++;
	}
	return (double)Correct/(double)m_TotalExamples*100.0;
}

//actually we don't need number of cols as they are the total features
//We are making a BIG ASSUMPTION that this class is positive
void DataEM::TestValidData(DataEM &NegClass,double **Instances,double *labels,
							 int rows,int cols,double *pPosCorrect,double *pNegCorrect)
{
	assert(m_UseLogProb);
	assert(cols == m_TotalFeatures);
	int i;
	double prob1,prob2,LogClassProb1,LogClassProb2;
	int PosCorrect=0,NegCorrect=0,TotalPos=0,TotalNeg=0,TotalExamples;
	assert(m_ExampleType == POSITIVE);
	//first lets calc the prior of each class as we have to apply Baye's theorem here

	TotalExamples = m_TotalExamples+NegClass.m_TotalExamples;
	LogClassProb1 = log10((double)m_TotalExamples/(double)TotalExamples);
	LogClassProb2 = log10((double)NegClass.m_TotalExamples/(double)TotalExamples);

	//for each instance
	for (i=0;i<rows;++i)
	{
		prob1 = LogClassProb1+ProbOfClass(Instances[i]);
		//now prob of other class
		prob2 = LogClassProb2+NegClass.ProbOfClass(Instances[i]);

		//now check the label
		if (prob1 > prob2 && labels[i] == POSITIVE_LABEL)
			PosCorrect++;
		if (prob2 > prob1 && labels[i] == NEGATIVE_LABEL)
			NegCorrect++;

		//count the totals
		if (labels[i] == POSITIVE_LABEL)
			TotalPos++;
		if (labels[i] == NEGATIVE_LABEL)
			TotalNeg++;
	}

	*pPosCorrect = (double)PosCorrect/(double)TotalPos*100.0;
	*pNegCorrect = (double)NegCorrect/(double)TotalNeg*100.0;
}

//data is given as 1d array in matlab format
void DataEM::Train(double *Data,int row,int col,int mixtures,int iterations)
{
	int index=0,c,r,i;
	//first put the values for features matrix
	m_TotalExamples = row;
	m_TotalFeatures = col;
	m_TotalMixtures = mixtures;
	AllocMatrix(&m_Features,row,col);
	
	for (c=0;c<col;++c)
	{	for (r=0;r<row;++r)
		{
			m_Features[r][c] = Data[index];
			index++;
		}
	}
	
	ofstream Strm("tmp.txt");
	
	Initialize();
	for (i=0;i<iterations;++i)
	{
		EStep();
		MStep();
		Strm << "\n\n Iteration number " << i << "\n";
		PrintMatrix(m_Z,m_TotalExamples,m_TotalMixtures,&Strm);
		
	}


}

//to use if you want to break train into two functions
//and want to use your own values to initialize
//data is given as 1d array in matlab format
//or features matrix as it is with values
//one of them (data or features matrix will be null
void DataEM::InitTrain(double *Data,int row,int col,int mixtures,float seedVal/*=0*/,double **featuresMatrix /*=0*/)
{
	int index=0,c,r;
	//first put the values for features matrix
	m_TotalExamples = row;
	m_TotalFeatures = col;
	m_TotalMixtures = mixtures;

	if (Data)
	{	
		assert(!featuresMatrix);
		AllocMatrix(&m_Features,row,col);
	
		for (c=0;c<col;++c)
		{	for (r=0;r<row;++r)
			{
				m_Features[r][c] = Data[index];
				index++;
			}
		}
	}
	else
	{
		assert(!Data);
		m_Features = featuresMatrix;
	}

	m_AddSeed = seedVal;
		
	Initialize();
}



//to use if you want to break train into two functions
//and want to use your own values to initialize
//data is given as 1d array in matlab format
void DataEM::TrainOnly(int iterations)
{
	int i;
	for (i=0;i<iterations;++i)
	{
		EStep();
		MStep();		
	}


}



