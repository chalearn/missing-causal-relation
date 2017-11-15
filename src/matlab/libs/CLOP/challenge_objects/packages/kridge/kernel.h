#ifndef _KERNEL_H_
#define _KERNEL_H_

//#include "CImg.h"
#include "doublematrixfunctor.h"


//#define KERNELIMAGE

#ifndef KERNELIMAGE
#define ACCESS(i,j)
#else
#define	ACCESS(i,j) protocoll->access(i,j);
#endif 
class kernel:public doublematrixfunctor

{
protected:
	int totalcalls;
	double *m_dataptr;
	int m_l;
	int m_dim;

#ifdef KERNELIMAGE

	class kernel_access_protocoll
	{
	public:
		char name[255];
		cimg_library::CImg<unsigned char>*img;
		kernel_access_protocoll::~kernel_access_protocoll()
		{
			img->save_bmp(name);
			delete img;
		}
		kernel_access_protocoll(char*n,int s)
		{

			strcpy(name,n);
			strcat(name,".bmp");
			img = new cimg_library::CImg<unsigned char>(s*7,s*7,1,1);        // Define a 640x400 color image with 8 bits per color component.
			img->fill(0);
		}
		void access(int i,int j){ 

			for(int k1=1;k1<6;k1++)
				for(int k2=1;k2<6;k2++)
					(*img)(i*7+k1,j*7+k2)=255;
		}


	} *protocoll;
#endif

public:

#ifdef KERNELIMAGE
	void makesnapshot(char *filename);
#endif

	kernel::~kernel();
	kernel(double *_Pdata,int _Pnrofpts,int _Pdim);
	virtual double  operator () (int _Px, int  _Py) =0;
	const int get_totalcalls(){return totalcalls;}
	void reset_totalcalls(){totalcalls=0;}
};

class linearkernel:public kernel
{
public:

	linearkernel(double *_Pdata,int _Pnrofpts,int _Pdim);

	double  operator () (int  _Px, int  _Py) ;
};


class polykernel:public kernel
{
public:
	int d;
	int coef;

	polykernel(double *_Pdata,int _Pnrofpts,int _Pdim, int _Pd,int _Pc);

	double  operator () (int  _Px, int  _Py) ;
};

class rbfkernel:public kernel
{
public:
	double gamma;

	rbfkernel(double *_Pdata,int _Pnrofpts,int _Pdim,double _Pgamma);

	double  operator () (int  _Px, int  _Py) ;
};

#endif

