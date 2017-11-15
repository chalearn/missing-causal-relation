//CODE by mehreen saeed, FAST National University of Computer and Emerging Sciences
//Lahore Pakistan.  mehreen.saeed@nu.edu.pk mehreen.mehreen@gmail.com


#ifndef EM_H
#define EM_H



#define LOGBASE  10


const double PIE = 3.1415926535897;
int const POSITIVE_LABEL = 1;
int const NEGATIVE_LABEL = -1;
const unsigned char BYTE_MAXI = 255;
const int SCALE	= 1;

typedef enum {POSITIVE,NEGATIVE} tExampleType;
typedef enum {GAUSSIAN,BERNOULLI,BINOMIAL} tModelType;


//main class for EM
class EM
{
public:

	EM(int TotalMixtures=100);
	virtual ~EM();
	void Initialize();
	virtual void EStep();
	virtual void MStep();
	int ClassifyOnDistance(int ExampleIndex);
	int ClassifyOnProb(int ExampleIndex,double *pMaxProb=NULL);
	int ClassifyOnProb(double *TestInstance,double *pMaxProb=NULL);
	void SetModel(tModelType ModelType);
	void WriteProb(char *FileName);
	void WriteInstanceProb(char *FileName,EM *pClass2EM=NULL);
	void WriteInstanceProb(char *FileName,double **Instances,int row,int col,EM *pClass2EM=NULL);

	void EStepWithLog();




//private members
protected:

	double CalcGaussian(int Row,int MixNumber);
	double CalcGaussian(double *Instance,int MixNumber);
	double CalcProbability(int Row,int MixNumber);
	double CalcProbability(double *Instance,int MixNumber);
	virtual double CalcBernoulli(int Row,int MixNumber);
	virtual double CalcBernoulli(double *Instance,int MixNumber);
	double CalcBinomial(double *Instance,int MixNumber);
	double CalcBinomial(int Row,int MixNumber);

	virtual void UpdateBernoulliProb();
	void UpdateBinomialProb();
	double Distance(int MixIndex,int ExampleIndex);
	virtual void UpdatePriors();
	void UpdateMeans();
	void UpdateCovrianceMatrices();
	int SetInvCovAndDet();
	void InitializeBernoulli();
	void InitializeBinomial();

	double **m_Features;
	double ***m_InvCov;
	double **m_Z;		//these are the hidden variables
	double *m_Determinant;
	int m_TotalFeatures;
	int m_TotalExamples;
	int m_TotalMixtures;
	tModelType m_ModelType;
	bool m_UseLogProb;
	float m_AddSeed;

//those members that we would like external access to
public:
	double *m_Prior;	//these are priors for each mixture
	double **m_Prob;	//probabilites in case of Bernoullis
	double ***m_Cov;	//covariance matrix in case of Gaussians
	double **m_Mean;	//means in case of Gaussians	
	double *m_SumZ;   //we'll keep this array of sums of zij along data columns so that we don't have to do it again & again

};


//em for databases
class DataEM:public EM
{
public: 

	DataEM(int TotalClusters,tExampleType et=POSITIVE,tModelType mt = BERNOULLI);
	void ReadData(char *FileName);
	void ReadSparseData(char *FileName);

	void TestData(char *OutFile);
	double TestTrainData(EM &emClass1);
	double TestTrainData1(DataEM &emClass1);
	double ProbOfClass(double *Instance);
	void TestValidData(DataEM &NegClass,double **Instances,double *labels,
						 int rows,int cols,double *pPosCorrect,double *pNegCorrect);
	void SetDataMatrix(double **InputMatrix,int rows,int cols);
	void Train(double *Data,int row,int col,int mixtures,int iterations);
	virtual void InitTrain(double *Data,int row,int col,int mixtures,float seedVal=0,double **featuresMatrix =0);

	virtual void InitTrain(double *Data,int row,int col,int mixtures,float seedVal,int *rowIndex,int *colIndex){assert(false);}	//don't come here;

	virtual void TrainOnly(int iterations);




protected:
	tExampleType m_ExampleType;
};



#endif