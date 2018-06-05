#include <cmath>
#include <math.h>
#include "stdio.h"
#include "stdlib.h"
using namespace std; 

#ifndef PI 
#define PI 3.141592653589793238462643
#endif

//The normal probability distribution function    
double norm_pdf(const double& z) {  
    return (1.0/sqrt(2.0*PI))*exp(-0.5*z*z);
};


//The normal cumulative distribution function 
double norm_cdf(const double& d)
{
    const double   A0 = 0.2316419;
    const double   A1 = 0.31938153;
    const double   A2 = -0.356563782;
    const double   A3 = 1.781477937;
    const double   A4 = -1.821255978;
    const double   A5 = 1.330274429;

    double RSQRT2PI = sqrt(2*PI);

    double cnd,K,LL;

    K = 1.0/(1.0+A0*fabs(d));
    LL=pow(fabs(d),2);

    cnd = 1.0-1.0/sqrt(2*PI)*exp(-0.5*LL)*(A1*K+A2*K*K+A3*pow(K,3)+A4*pow(K,4)+A5*pow(K,5));
    
    if (d<0)
    	cnd=1.0-cnd;

    return cnd;
}
