#include <math.h>
#include "stdio.h"
#include "stdlib.h"

//The cumulative normal distribution function 
double CND(double d)
{
    const double   A0 = 0.2316419;
    const double   A1 = 0.31938153;
    const double   A2 = -0.356563782;
    const double   A3 = 1.781477937;
    const double   A4 = -1.821255978;
    const double   A5 = 1.330274429;
    const double   PI = 3.141592653589793238462643; 

    double RSQRT2PI = sqrt(2*PI);

    double K;
    K = 1.0/(1.0+A0*fabs(d));

    double cnd,cnd1,cnd2;

    cnd1 = RSQRT2PI*exp(-0.50*d*d)*(K*(A1+K*(A2+K*(A3+K*(A4+K*A5)))));
	
    double LL=fabs(d);
    cnd2 = 1.0-1.0/sqrt(2*PI)*exp(-0.5*LL*LL)*(A1*K+A2*K*K+A3*pow(K,3)+A4*pow(K,4)+A5*pow(K,5));
    
 
    if (d>0)
        cnd1 = 1.0 - cnd1;

    if (d<0)
    	cnd2=1.0-cnd2;

    printf("cnd1=%lf,cnd2=%lf\n",cnd1,cnd2);
    if (fabs(cnd1-cnd2)<0.000000001)
    {
    	printf("The test success...");
    	cnd=cnd1;
    }



    return cnd;
}

void BlackScholes(
    double& callResult,//call premium
    double& putResult,//put premium
    double S, //stock price
    double X, //strike price
    double T, //maturity
    double t, //current time
    double R, //riskfree rate
    double V  //volatility
)
{
    double sqrtT = sqrt(T-t);
    double    d1 = (log(S/X)+(R+0.5*V*V)*(T-t))/(V*sqrtT);
    double    d2 = d1-V*sqrtT;
    double CNDD1 = CND(d1);
    double CNDD2 = CND(d2);
    double expRT = exp(-R*(T-t));

    callResult   = (S*CNDD1-X*expRT*CNDD2);
    putResult    = (X*expRT*(1.0-CNDD2)-S*(1.0-CNDD1));
}


int main(int argc, char **argv)
{

    double CallPrice;
    double PutPrice;
    double S;
    double K;
    double T;
    double t;
    double Rf;
    double Vol;

    //Initial Info
    S=50.00;
    K=45.00;
    T=1.0;
    t=0.1;
    Rf=0.02;
    Vol=0.0125;

    BlackScholes(CallPrice,PutPrice,S,K,T,t,Rf,Vol);
    //Print Results
    printf("\t=======AD==========\n");
    printf("\t I LOVE CUEB, CUEB, CUEB.\n");
    printf("\t We LOVE School of Finance\n ");
    printf("\t===================\n");

    printf("When\tStock Price=%lf\tStrike Price=%lf\t\n",S,K);
    printf("\tTime remain=%lf\n",T-t);
    printf("\tRisk-free rate=%lf\tVolatility=%lf\n",Rf,Vol);
    printf("Our Results are listed below:\n");
    printf("Call Premium=%lf \n Put Premium=%lf\n",CallPrice,PutPrice);
    printf("==================\n");

    //we demo another exmaple
    S=40.00;
    K=45.00;
    T=1.0;
    t=0.2;
    Rf=0.02;
    Vol=0.0125;

    BlackScholes(CallPrice,PutPrice,S,K,T,t,Rf,Vol);
    //Print Results
    printf("When\tStock Price=%lf\tStrike Price=%lf\t\n",S,K);
    printf("\tTime remain=%lf\n",T-t);
    printf("\tRisk-free rate=%lf\tVolatility=%lf\n",Rf,Vol);
    printf("Our Results are listed below:\n");
    printf("Call Premium=%lf \n Put Premium=%lf\n",CallPrice,PutPrice);
}