#include <math.h>
#include <mex.h>
#include "kernel.h"

kernel::kernel(double *_Pdata,int _Pnrofpts,int _Pdim)
{
	m_dataptr=_Pdata;
	m_l=_Pnrofpts;
	m_dim=_Pdim;
	totalcalls=0;

}

kernel::~kernel()
{
#ifdef KERNELIMAGE
	delete protocoll;
#endif
}

#ifdef KERNELIMAGE
void kernel::makesnapshot(char *filename)
{

	protocoll=new kernel_access_protocoll(filename,m_l);
}
#endif

linearkernel::linearkernel(double *_Pdata,int _Pnrofpts,int _Pdim)
: kernel(_Pdata,_Pnrofpts,_Pdim)
{
}



double linearkernel::operator () (int _Px, int _Py) 
{
	totalcalls++;
	ACCESS(_Px,_Py);
	double s=0;
	for(int i=0;i<m_dim;i++)
	{
		s+=m_dataptr[ _Px+i*m_l]*m_dataptr[_Py+i*m_l];
	}
	return s;
}





polykernel::polykernel(double *_Pdata,int _Pnrofpts,int _Pdim, int _Pd,int _Pc)
:kernel(_Pdata,_Pnrofpts,_Pdim)
{
	d=_Pd;
	coef=_Pc;
}
double  polykernel::operator () (int _Px, int _Py) 
{
	totalcalls++;
	
	ACCESS(_Px,_Py);
	double s=0;
	for(int i=0;i<m_dim;i++)
	{
		s+=m_dataptr[ _Px+i*m_l]*m_dataptr[_Py+m_l*i];
	}
	return pow(s+coef,d);
}







rbfkernel::rbfkernel(double *_Pdata,int _Pnrofpts,int _Pdim, double _Pg)
:kernel(_Pdata, _Pnrofpts,_Pdim)
{
	gamma=_Pg;
}

double  rbfkernel::operator () (int _Px, int _Py) 
{
	totalcalls++;
	
	ACCESS(_Px,_Py);
	double s=0;
	for(int i=0;i<m_dim;i++)
	{
		s+=(m_dataptr[ _Px+m_l*i]-m_dataptr[_Py+m_l*i])
			*(m_dataptr[ _Px+m_l*i]-m_dataptr[_Py+m_l*i]);
	}
	return exp(- gamma * s);
}