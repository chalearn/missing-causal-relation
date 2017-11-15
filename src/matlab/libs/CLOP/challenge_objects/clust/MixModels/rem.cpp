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
#include "rem.h"


//the intitialization of variables is the same as for the parent class
//implementation file for regularized EM
//right now we only cater for Bernoulli distributions
REM::REM(int TotalClusters,tExampleType et/*=POSITIVE*/,tModelType mt /*= BERNOULLI*/,
		 double gamma /*= 0.05*/):DataEM(TotalClusters,et,mt)
{
	m_gamma = gamma;
}

//e step is the  same as e step for parent class except that we will make
//m_sumZ[j] = (sum over all instances) z[j]*(1+gamma*ln z[j])
void REM::EStep()
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

void REM::MStep()
{
	assert(m_UseLogProb);
	assert(m_ModelType == BERNOULLI);
	UpdatePriors();
	UpdateBernoulliProb();
	
}

//in this case m_SumZ has the regularized parameter for denominator of update prob
//m_sumZ[j] = (sum over all instances) z[j]*(1+gamma*ln z[j])
void REM::UpdatePriors()
{	
	int j;

	double denom = 0;
	for (j=0;j<m_TotalMixtures;++j)
		denom += m_SumZ[j];

	for (j=0;j<m_TotalMixtures;++j)
		m_Prior[j] = m_SumZ[j]/denom;
}

void REM::UpdateBernoulliProb()
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
				
				if (m_Features[i][j] && m_Z[i][m])
					numerator += m_Z[i][m]*(1+m_gamma * log(m_Z[i][m]));
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
void REM::TrainOnly(int iterations)
{
	int i;
	for (i=0;i<iterations;++i)
	{
		EStep();
		MStep();		
	}


}

