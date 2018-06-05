#include <cmath>              // mathematical library
#include "normdist.h"          // this defines the normal distribution
using namespace std; 

double BS_put_Price(const double& S,      // spot price
				      const double& K,      // Strike (exercise) price,
				      const double& r,      // interest rate
				      const double& sigma,  // volatility
				      const double& TT,
				      double& tt){
	double time = TT -tt;
    double time_sqrt = sqrt(time);
    double d1 = (log(S/K)+r*time)/(sigma*time_sqrt) + 0.5*sigma*time_sqrt;
    double d2 = d1-(sigma*time_sqrt);
    return K*exp(-r*time)*norm_cdf(-d2) - S*norm_cdf(-d1);
};
