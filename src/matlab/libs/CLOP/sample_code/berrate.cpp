// Filename: berrate.cpp
// 
// Author: Steve Gunn (srg@ecs.soton.ac.uk)
//
// Date: 01/09/2003
//
// Description: Routine for calculating the balanced error rate. 
// 
// Usage: berrate data.labels data.resu
//
// Comments: labels file contains +/-1 truth values
//           resu file contains predicted +/-1 calues
//
// Error Conditions
// ----------------
// 1 - Incorrect number of arguments
// 2 - Failed to open labels file
// 3 - Failed to open resu file
// 4 - Invalid labels file
// 5 - Invalid resu file
// 6 - Too many examples in resu file
// 7 - Too few examples in resu file
// 8 - Labels file empty

#include <iostream>
#include <fstream>
#include <cstdlib>

using namespace std;

int main(int argc, char* argv[])
{
	if (argc!=3) exit(1);

	int it, is;
	unsigned int n=0;
	unsigned int dn=0;
	unsigned int dp=0;
	unsigned int pn=0;
	unsigned int nn=0;

	ifstream labels(argv[1]);
	if (labels.fail()) exit(2);
	labels >> ws;
	ifstream resu(argv[2]);
	if (resu.fail()) exit(3);
	resu >> ws;
	while(!labels.eof() && !resu.eof()) {
		labels >> it >> ws;
		if (labels.fail()) exit(4);
		resu >> is >> ws;
		if (resu.fail()) exit(5);
		n++;
		if (is!=1 && is!=-1) exit(5);
		if (it==1) {
			pn++;
			if (is!=1) dp++;
		}
		if (it==-1) {
			nn++;
			if (is!=-1) dn++;
		}
		if (labels.eof() && !resu.eof()) exit(6);
		if (!labels.eof() && resu.eof()) exit(7);
	}
	labels.close();
	resu.close();
	if ((pn+nn)==0) exit(8);

	double res = 0.0;
	if (pn!=0) 
		res += (double)dp/pn;
	else
		res += 1.0;
	if (nn!=0) 
		res += (double)dn/nn;
	else
		res += 1.0;
	cout << (double)res/2.0;

	return 0;
}

