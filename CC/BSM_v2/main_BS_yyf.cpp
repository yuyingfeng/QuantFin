#include <iostream>
#include "bs.h"
#include "time.h"
using namespace std;

int main(int argc, char **argv)
{

//checking CPU runing time
    clock_t start_time, end_time;  
    double  duration_time;  
    start_time=clock();  

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
    t=0.01;
    Rf=0.02;
    Vol=0.0125;

    cout << " Black Scholes call price = ";
    cout << BS_call_Price(S,K,Rf,Vol,T,t) << endl;

    cout << " Black Scholes put price = ";
    cout << BS_put_Price(S,K,Rf,Vol,T,t) << endl;
     cout  <<"***********************************************"<< endl;

    double Delta,Gamma,Kappa,Theta,Vega,Rho;

    cout  << " Option deltas : Black Scholes Model  " << endl;
    Delta = BS_delta_call(S,K,Rf,Vol,T,t);
    cout << " Call Option Delta = " << Delta << endl;
    Delta = BS_delta_put(S,K,Rf,Vol,T,t);
    cout << " Put Option Delta = " << Delta << endl;

    cout  <<"***********************************************"<< endl;
    cout  << " Call Option Black Scholes greeks  " << endl;
    BS_Greeks_call(S,K,Rf,Vol,T,t,Delta,Gamma,Kappa,Theta,Vega,Rho);
    cout << "  Delta = " << Delta << endl;
    cout << "  Gamma = " << Gamma << endl;
    cout << "  Kappa = " << Kappa << endl;
    cout << "  Theta = " << Theta << endl;
    cout << "  Vega  = " << Vega << endl;
    cout << "  Rho   = " << Rho << endl;

    cout  << " Put Option Black Scholes greeks  " << endl;
    BS_Greeks_put(S,K,Rf,Vol,T,t,Delta,Gamma,Kappa,Theta,Vega,Rho);
    cout << "  Delta = " << Delta << endl;
    cout << "  Gamma = " << Gamma << endl;
    cout << "  Kappa = " << Kappa << endl;
    cout << "  Theta = " << Theta << endl;
    cout << "  Vega  = " << Vega << endl;
    cout << "  Rho   = " << Rho << endl;



    end_time = clock();  
    duration_time = (double)(end_time-start_time) / CLOCKS_PER_SEC;  
    printf( "duration: %lf seconds\n", duration_time );      

}

