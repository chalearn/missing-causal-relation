#ifndef SPARSEREM_H
#define SPARSEREM_H


//CODE by mehreen saeed, FAST National University of Computer and Emerging Sciences
//Lahore Pakistan.  mehreen.saeed@nu.edu.pk mehreen.mehreen@gmail.com
//this is the class for regularized EM for sparse data
//the data will have to be Matlab sparse data
//m_rowIndex and m_colIndex are the indices passed by matlab
class REMSparse:public DataEM
{
public:
	REMSparse(int TotalClusters,tExampleType et=POSITIVE,tModelType mt = BERNOULLI,double gamma = 0.05);
	virtual void InitTrain(double *Data,int row,int col,int mixtures,float seedVal,int *rowIndex,int *colIndex);
	virtual void TrainOnly(int iterations);
	virtual void UpdateBernoulliProb();
	virtual void UpdatePriors();
	virtual double CalcBernoulli(int Row,int MixNumber);
	virtual void EStep();
	virtual void MStep();

protected:
	int GetFeatureValue(int rowNumber,int col);
	bool Search(int StartIndex,int EndIndex,int *arr,int Value);


	double m_gamma;		//this is the regularization constant
	int *m_rowIndex;	//passed by matlab
	int *m_colIndex;	//passed by matlab
};

#endif