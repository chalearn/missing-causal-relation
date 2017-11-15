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
#include "REMSparse.h"



//the intitialization of variables is the same as for the parent class
//implementation file for regularized EM
//right now we only cater for Bernoulli distributions
REMSparse::REMSparse(int TotalClusters,tExampleType et/*=POSITIVE*/,tModelType mt /*= BERNOULLI*/,
		 double gamma /*= 0.05*/):DataEM(TotalClusters,et,mt)
{
	m_gamma = gamma;
	m_rowIndex = NULL;
	m_colIndex = NULL;
}


//initialize for training
//to use if you want to break train into two functions
//and want to use your own values to initialize
//data is given as 2 1d arrays in matlab format...its understood that colIndex and rowIndex has value of binary 1 as we
//are dealing with binary data
//the caller is responsible for de-allocating rowIndex and colIndex arrays
void REMSparse::InitTrain(double *Data,int row,int col,int mixtures,float seedVal,int *rowIndex,int *colIndex)
{
	int index=0;
	//first put the values for features matrix
	m_TotalExamples = row;
	m_TotalFeatures = col;
	m_TotalMixtures = mixtures;

	//these are in matlab format
	m_rowIndex = rowIndex;
	m_colIndex = colIndex;

	m_AddSeed = seedVal;
		
	Initialize();
}




//e step is the  same as e step for parent class except that we will make
//m_sumZ[j] = (sum over all instances) z[j]*(1+gamma*ln z[j])
void REMSparse::EStep()
{
	assert(m_UseLogProb);
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
			if (m_Z[i][j])
				m_SumZ[j] += m_Z[i][j]*(1+m_gamma*log(m_Z[i][j]));

			assert(m_Z[i][j] >= 0 && m_Z[i][j] <= 1);
			if(m_SumZ[j] <= 0)
				m_SumZ[j] = 1E-200;
		}

	}

	delete [] RowZ;
}

void REMSparse::MStep()
{
	assert(m_UseLogProb);
	assert(m_ModelType == BERNOULLI);
	UpdatePriors();
	UpdateBernoulliProb();
	
}

//in this case m_SumZ has the regularized parameter for denominator of update prob
//m_sumZ[j] = (sum over all instances) z[j]*(1+gamma*ln z[j])
void REMSparse::UpdatePriors()
{	
	int j;

	double denom = 0;
	for (j=0;j<m_TotalMixtures;++j)
		denom += m_SumZ[j];

	for (j=0;j<m_TotalMixtures;++j)
		m_Prior[j] = m_SumZ[j]/denom;
}


void REMSparse::UpdateBernoulliProb()
{
	int i,j,m,row;
	double numerator=0;
	int nextIndex = 0;

	for (m=0;m<m_TotalMixtures;++m)
	{
		nextIndex = 0;

		for (j=0;j<m_TotalFeatures;++j)
		{
			numerator = 0;
			//sum only the zij for which xij is one...we are optimising it now
			for (i=0;i<m_colIndex[j+1]-m_colIndex[j];++i)
			{
				row = m_rowIndex[nextIndex];
				if (m_Z[row][m])
					numerator += m_Z[row][m]*(1+m_gamma * log(m_Z[row][m]));
				nextIndex++;
			}
			//now the new probability..use Laplacian prior to smooth
			m_Prob[m][j] = (1+numerator)/(2+m_SumZ[m]);
			assert(m_Prob[m][j]>0 && m_Prob[m][j]<1);
			assert(m_Prob[m][j]>0 && m_Prob[m][j]<1);


		}
	}

}

//to use if you want to break train into two functions
//and want to use your own values to initialize
//data is given as 1d array in matlab format
void REMSparse::TrainOnly(int iterations)
{
	int i;
	for (i=0;i<iterations;++i)
	{
		EStep();
		MStep();		
	}


}

//does binary search
//Value is the value to search for
bool REMSparse::Search(int StartIndex,int EndIndex,int *arr,int Value)
{
	bool found = false;
	int start = StartIndex;
	int end = EndIndex;
	int mid;

	while(!found&&end>=start)
	{
		mid = (start+end)/2;
		
		if (Value < arr[mid])
			end = mid-1;
		else if (Value > arr[mid])
			start = mid+1;
		else
			found = true;
	}

	return found;
}



int REMSparse::GetFeatureValue(int rowNumber,int col)
{

	int index,value;

	value = 0;
	index = m_colIndex[col];

	//we have to check whether there is a one at this col or not
	if (Search(m_colIndex[col],m_colIndex[col+1]-1,m_rowIndex,rowNumber))
		value = 1;
	return value;
}

//calculate probability for bernoulli
//we'll calculate the prob here and multiply them with SCALE factor everytime to keep the
//scale right
//or just simply use log prob
double REMSparse::CalcBernoulli(int Row,int MixNumber)
{

	int col;
	double Sum=1;
	int value = 0;


	//not using log prob
	if (!m_UseLogProb)
	{
		for (col=0;col<m_TotalFeatures;++col)
		{
			value = GetFeatureValue(Row,col);
			if (value)
				Sum *= m_Prob[MixNumber][col] * SCALE;
			else
				Sum *= (1-m_Prob[MixNumber][col]) * SCALE;
		}
	}

	else //using log prob
	{
		Sum = 0;
		for (col=0;col<m_TotalFeatures;++col)
		{
			assert(m_Prob[MixNumber][col]!=0);
			assert(m_Prob[MixNumber][col]!=1);

			if (GetFeatureValue(Row,col))
				Sum += log10(m_Prob[MixNumber][col]) ;
			else
				Sum += log10(1-m_Prob[MixNumber][col]) ;
		}

	}

	return Sum;
}



