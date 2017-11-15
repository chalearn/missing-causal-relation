// Filename: auc.cpp
// 
// Author: Steve Gunn (srg@ecs.soton.ac.uk)
//
// Date: 01/09/2003
//
// Description: Routine for calculating the area under the ROC curve. 
// 
// Usage: auc data.labels data.resu data.conf
//
// Comments: labels file contains +/-1 truth values
//           resu file contains predicted +/-1 calues
//           conf file contains positive real confidence values (not necessarily probabilities).
//
// Error Conditions
// ----------------
// 1 - Incorrect number of arguments
// 2 - Failed to open labels file
// 3 - Failed to open resu file
// 4 - Failed to open conf file
// 5 - Invalid labels file
// 6 - Invalid resu file
// 7 - Invalid conf file
// 8 - Too many examples in resu file
// 9 - Too few examples in resu file
// 10 - Too many examples in conf file
// 11 - Too few examples in conf file
// 12 - labels file empty

#include <iostream>
#include <fstream>
#include <cstdlib>

using namespace std;

int main(int argc, char* argv[])
{
	if (argc!=3 && argc!=4) exit(1);

	int i, j;
	int it;
	double is;
	unsigned int n=0;

	ifstream labels(argv[1]);
	if (labels.fail()) exit(2);
	labels >> ws;
	ifstream resu(argv[2]);
	if (resu.fail()) exit(3);
	resu >> ws;
	while(!labels.eof() && !resu.eof()) {
		labels >> it >> ws;
		if (labels.fail()) exit(5);
		resu >> is >> ws;
		if (resu.fail()) exit(6);
		n++;
		if (labels.eof() && !resu.eof()) exit(8);
		if (!labels.eof() && resu.eof()) exit(9);
	}
	labels.close();
	resu.close();
	if (n==0) exit(12);
	if (argc==4) {
		unsigned int nc=0;
		ifstream conf(argv[3]);
		if (conf.fail()) exit(4);
		conf >> ws;
		while(!conf.eof()) {
			conf >> is >> ws;
			if (conf.fail()) exit(7);
			nc++;
			if (nc==n && !conf.eof()) exit(10);
			if (nc<n && conf.eof()) exit(11);
		}
		conf.close();
	}

	int *t;
	t = new int[n]; 
	ifstream labels1(argv[1]);
	if (labels1.fail()) exit(2);
	labels1 >> ws;
	for(i=0; i<n; i++)
		labels1 >> t[i] >> ws;
	labels1.close();

	double *s;
	s = new double[n]; 
	if (argc==4) {
		ifstream conf1(argv[3]);
		if (conf1.fail()) exit(4);
		conf1 >> ws;
		for(i=0; i<n; i++) 
			conf1 >> s[i] >> ws;
		conf1.close();
	} else 
		for(i=0; i<n; i++) 
			s[i] = 1.0;
	
	ifstream resu1(argv[2]);
	if (resu1.fail()) exit(3);
	resu1 >> ws;
	for(i=0; i<n; i++) {
		resu1 >> it >> ws;
		if (it==-1) s[i] = -s[i];
	}
	resu1.close();


    unsigned int correct = 0; 
    unsigned int valid = 0;
    for(i=0; i<n-1; i++)
        for(j=i+1; j<n; j++)
            if (t[i] != t[j]) {
                valid++;
                if (s[i] == s[j])
                    correct++;
                else 
					if (t[i] == -1) {
						if (s[i] < s[j])
							correct += 2;
					}
					else
						if (s[j] < s[i])
							correct += 2;
			}

	if (valid==0)
		cout << 0;
	else
		cout << (double)correct/(2*valid);

	delete[] t;
	delete[] s;

	return 0;
}

