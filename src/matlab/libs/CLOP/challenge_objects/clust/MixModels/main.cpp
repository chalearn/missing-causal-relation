//example file that shows how to run the program from C++
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

void RunSylvaExper()
{

	double ValidPos,ValidNeg,PosAcc,NegAcc;
//	Initialize the models for +ve and -ve examples
	REM PosEM(3,POSITIVE,BERNOULLI,0.2); 
	REM NegEM(3, NEGATIVE,BERNOULLI,0.2);


	PosEM.ReadData("data\\sylvabin_train");
	NegEM.ReadData("data\\sylvabin_train");
	PosEM.Initialize();
	NegEM.Initialize();
	
	

//	Lets read the validation set also
	
	double **Instances,*labels;
	double **TrainInstances,*TrainLabels;
	int rows,cols,row1,col1;
	ReadDataInMatrix("data\\sylvabin_valid",
					&Instances,&labels,rows,cols);
	ReadDataInMatrix("data\\sylvabin_train",
					&TrainInstances,&TrainLabels,row1,col1);



	for (int i=0;i<40;++i)
	{

		//write the prob of instances in a mixture model
		PosEM.WriteInstanceProb("BerP.txt",&NegEM);
		NegEM.WriteInstanceProb("BerN.txt",&PosEM);
		PosEM.WriteInstanceProb("BerTrain.txt",TrainInstances,row1,col1,&NegEM);
		PosEM.WriteInstanceProb("BerValid.txt",Instances,rows,cols,&NegEM);

		//test the validation set
		PosEM.TestValidData(NegEM,Instances,labels,rows,cols,&ValidPos,&ValidNeg);
		//test the train set
		PosAcc = PosEM.TestTrainData1(NegEM);
		NegAcc = NegEM.TestTrainData1(PosEM);
		//write them out
		cout << "\n\n" << "Iteration " << i;
		cout << "\n Train Positive % " <<  PosAcc;
		cout << "\n Train Negative % " <<  NegAcc;
		cout << "\n Train Accuracy % " << (PosAcc+NegAcc)/2;
		cout << "   Train Error % "	   <<  100 - (PosAcc+NegAcc)/2;
		cout << "\n Valid Positive % " << ValidPos;
		cout << "\n Valid Negative % " << ValidNeg;
		cout << "\n Valid Accuracy % " << (ValidPos+ValidNeg)/2;
		cout << "   Valid Error % "    << 100 -  (ValidPos+ValidNeg)/2;

		PosEM.EStep();
		PosEM.MStep();
		NegEM.EStep();
		NegEM.MStep();


		cout.flush();

	}

	cin >> i;

	DeAllocateMatrix(Instances,rows);
	DeAllocateMatrix(TrainInstances,rows);

	delete [] TrainLabels;
	delete [] labels;

}


void RunNovaExper()
{	
	int i,j;
	const int PosMix=15,NegMix=5;
	const int total=5;
	const int iterations=20;
//	Initialize the models for +ve examples

	DataEM em(PosMix,POSITIVE,BERNOULLI);
	em.ReadSparseData("data\\nova0.2many");
	em.Initialize();

	for (j=0;j<iterations;++j)
	{
		em.EStep();
		em.MStep();
	}

	cin >> i;



}



void main()
{
	//uncomment one of the following
//	RunNovaExper();
	RunSylvaExper();
}
