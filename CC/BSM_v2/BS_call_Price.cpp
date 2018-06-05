#include <cmath>             
#include "normdist.h"

double BS_call_Price(const double& S,       // spot (underlying) price
				       const double& K,       // strike (exercise) price,
				       const double& r,       // interest rate
				       const double& sigma,   // volatility 
				       const double& TT,
				       double &tt) {  
    double time_sqrt = sqrt(TT-tt);
    double d1 = (log(S/K)+r*(TT-tt))/(sigma*time_sqrt)+0.5*sigma*time_sqrt; 
    double d2 = d1-(sigma*time_sqrt);
    return S*norm_cdf(d1) - K*exp(-r*(TT-tt))*norm_cdf(d2);
};
