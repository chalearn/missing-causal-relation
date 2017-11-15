#ifndef REM_H
#define REM_H

//CODE by mehreen saeed, FAST National University of Computer and Emerging Sciences
//Lahore Pakistan.  mehreen.saeed@nu.edu.pk mehreen.mehreen@gmail.com


//this is the class for regularized EM
//Reference: H. Li, K. Zhang, and T. Jiang,
//"The regularized EM algorithm", in Proceedings of the 20th National Conference 
//on Artificial Intelligence,2005, pp. 807-812.
class REM:public DataEM
{
public:
	REM(int TotalClusters,tExampleType et=POSITIVE,tModelType mt = BERNOULLI,double gamma = 0.05);
	void TrainOnly(int iterations);
	void UpdateBernoulliProb();
	void UpdatePriors();
	void EStep();
	void MStep();

protected:
	double m_gamma;		//this is the regularization constant
};

#endif